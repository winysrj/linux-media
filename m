Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54276 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab2IAPv1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2012 11:51:27 -0400
Received: by bkwj10 with SMTP id j10so1657818bkw.19
        for <linux-media@vger.kernel.org>; Sat, 01 Sep 2012 08:51:26 -0700 (PDT)
Message-ID: <50422EFA.5000606@gmail.com>
Date: Sat, 01 Sep 2012 17:51:22 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Juergen Lock <nox@jelal.kn-bremen.de>, hselasky@c2i.net
Subject: Re: Fwd: [PATCH, RFC] Fix DVB ioctls failing if frontend open/closed
 too fast
References: <20120731222216.GA36603@triton8.kn-bremen.de> <502711BE.4020701@redhat.com>
In-Reply-To: <502711BE.4020701@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/2012 04:15 AM, Mauro Carvalho Chehab wrote:
> Devin/Antti,
> 
> As Juergen mentioned your help on this patch, do you mind helping reviewing
> and testing it?
> 
> Touching on those semaphores can be very tricky, as anything wrong may cause
> a driver hangup. So, it is great to have more pair of eyes looking on it.
> 
> While I didn't test the code (too busy trying to clean up my long queue -
> currently with still 200+ patches left), I did a careful review at the
> semaphore code there, and it seems this approach will work.
> 
> At least, the first hunk looks perfect for me. The second hunk seems
> a little more worrying, as the dvb core might be waiting forever for
> a lock on a device that was already removed.
> 
> In order to test it in practice, I think we need to remove an USB device
> by hand while tuning it, and see if the core will not lock the device 
> forever.
> 
> What do you think?
> Mauro
> 
> -------- Mensagem original --------
> Assunto: [PATCH, RFC] Fix DVB ioctls failing if frontend open/closed too fast
> Data: Wed, 1 Aug 2012 00:22:16 +0200
> De: Juergen Lock <nox@jelal.kn-bremen.de>
> Para: linux-media@vger.kernel.org
> CC: hselasky@c2i.net
> 
> That likely fxes this MythTV ticket:
> 
> 	http://code.mythtv.org/trac/ticket/10830
> 
> (which btw affects all usb tuners I tested as well, pctv452e,
> dib0700, af9015)  pctv452e is still possibly broken with MythTV
> even after this fix; it does work with VDR here tho despite I2C
> errors.
> 
> Reduced testcase:
> 
> 	http://people.freebsd.org/~nox/tmp/ioctltst.c
> 
> Thanx to devinheitmueller and crope from #linuxtv for helping with
> this fix! :)
> 
> Signed-off-by: Juergen Lock <nox@jelal.kn-bremen.de>
> 
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -604,6 +604,7 @@ static int dvb_frontend_thread(void *dat
>  	enum dvbfe_algo algo;
>  
>  	bool re_tune = false;
> +	bool semheld = false;
>  
>  	dprintk("%s\n", __func__);
>  
> @@ -627,6 +628,8 @@ restart:
>  
>  		if (kthread_should_stop() || dvb_frontend_is_exiting(fe)) {
>  			/* got signal or quitting */
> +			if (!down_interruptible (&fepriv->sem))
> +				semheld = true;
>  			fepriv->exit = DVB_FE_NORMAL_EXIT;
>  			break;
>  		}
> @@ -742,6 +745,8 @@ restart:
>  		fepriv->exit = DVB_FE_NO_EXIT;
>  	mb();
>  
> +	if (semheld)
> +		up(&fepriv->sem);
>  	dvb_frontend_wakeup(fe);
>  	return 0;
>  }
> @@ -1804,16 +1809,20 @@ static int dvb_frontend_ioctl(struct fil
>  
>  	dprintk("%s (%d)\n", __func__, _IOC_NR(cmd));
>  
> -	if (fepriv->exit != DVB_FE_NO_EXIT)
> +	if (down_interruptible (&fepriv->sem))
> +		return -ERESTARTSYS;
> +
> +	if (fepriv->exit != DVB_FE_NO_EXIT) {
> +		up(&fepriv->sem);
>  		return -ENODEV;
> +	}
>  
>  	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
>  	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
> -	     cmd == FE_DISEQC_RECV_SLAVE_REPLY))
> +	     cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
> +		up(&fepriv->sem);
>  		return -EPERM;
> -
> -	if (down_interruptible (&fepriv->sem))
> -		return -ERESTARTSYS;
> +	}
>  
>  	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
>  		err = dvb_frontend_ioctl_properties(file, cmd, parg);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

+1
This one resolve annoying mythtv-setup output:
"E FE_GET_INFO ioctl failed (/dev/dvb/adapter0/frontend0)
eno: No such device (19)"
http://www.gossamer-threads.com/lists/mythtv/dev/513410

But, there is a new one!
Just had a little déjà vu :)

Cheers,
poma



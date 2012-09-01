Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37519 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2IAQOC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Sep 2012 12:14:02 -0400
Message-ID: <50423436.9040708@iki.fi>
Date: Sat, 01 Sep 2012 19:13:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Juergen Lock <nox@jelal.kn-bremen.de>, hselasky@c2i.net
Subject: Re: Fwd: [PATCH, RFC] Fix DVB ioctls failing if frontend open/closed
 too fast
References: <20120731222216.GA36603@triton8.kn-bremen.de> <502711BE.4020701@redhat.com> <50422EFA.5000606@gmail.com>
In-Reply-To: <50422EFA.5000606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/2012 06:51 PM, poma wrote:
> On 08/12/2012 04:15 AM, Mauro Carvalho Chehab wrote:
>> Devin/Antti,
>>
>> As Juergen mentioned your help on this patch, do you mind helping reviewing
>> and testing it?
>>
>> Touching on those semaphores can be very tricky, as anything wrong may cause
>> a driver hangup. So, it is great to have more pair of eyes looking on it.
>>
>> While I didn't test the code (too busy trying to clean up my long queue -
>> currently with still 200+ patches left), I did a careful review at the
>> semaphore code there, and it seems this approach will work.
>>
>> At least, the first hunk looks perfect for me. The second hunk seems
>> a little more worrying, as the dvb core might be waiting forever for
>> a lock on a device that was already removed.
>>
>> In order to test it in practice, I think we need to remove an USB device
>> by hand while tuning it, and see if the core will not lock the device
>> forever.
>>
>> What do you think?
>> Mauro
>>
>> -------- Mensagem original --------
>> Assunto: [PATCH, RFC] Fix DVB ioctls failing if frontend open/closed too fast
>> Data: Wed, 1 Aug 2012 00:22:16 +0200
>> De: Juergen Lock <nox@jelal.kn-bremen.de>
>> Para: linux-media@vger.kernel.org
>> CC: hselasky@c2i.net
>>
>> That likely fxes this MythTV ticket:
>>
>> 	http://code.mythtv.org/trac/ticket/10830
>>
>> (which btw affects all usb tuners I tested as well, pctv452e,
>> dib0700, af9015)  pctv452e is still possibly broken with MythTV
>> even after this fix; it does work with VDR here tho despite I2C
>> errors.
>>
>> Reduced testcase:
>>
>> 	http://people.freebsd.org/~nox/tmp/ioctltst.c
>>
>> Thanx to devinheitmueller and crope from #linuxtv for helping with
>> this fix! :)
>>
>> Signed-off-by: Juergen Lock <nox@jelal.kn-bremen.de>
>>
>> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
>> @@ -604,6 +604,7 @@ static int dvb_frontend_thread(void *dat
>>   	enum dvbfe_algo algo;
>>
>>   	bool re_tune = false;
>> +	bool semheld = false;
>>
>>   	dprintk("%s\n", __func__);
>>
>> @@ -627,6 +628,8 @@ restart:
>>
>>   		if (kthread_should_stop() || dvb_frontend_is_exiting(fe)) {
>>   			/* got signal or quitting */
>> +			if (!down_interruptible (&fepriv->sem))
>> +				semheld = true;
>>   			fepriv->exit = DVB_FE_NORMAL_EXIT;
>>   			break;
>>   		}
>> @@ -742,6 +745,8 @@ restart:
>>   		fepriv->exit = DVB_FE_NO_EXIT;
>>   	mb();
>>
>> +	if (semheld)
>> +		up(&fepriv->sem);
>>   	dvb_frontend_wakeup(fe);
>>   	return 0;
>>   }
>> @@ -1804,16 +1809,20 @@ static int dvb_frontend_ioctl(struct fil
>>
>>   	dprintk("%s (%d)\n", __func__, _IOC_NR(cmd));
>>
>> -	if (fepriv->exit != DVB_FE_NO_EXIT)
>> +	if (down_interruptible (&fepriv->sem))
>> +		return -ERESTARTSYS;
>> +
>> +	if (fepriv->exit != DVB_FE_NO_EXIT) {
>> +		up(&fepriv->sem);
>>   		return -ENODEV;
>> +	}
>>
>>   	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
>>   	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
>> -	     cmd == FE_DISEQC_RECV_SLAVE_REPLY))
>> +	     cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
>> +		up(&fepriv->sem);
>>   		return -EPERM;
>> -
>> -	if (down_interruptible (&fepriv->sem))
>> -		return -ERESTARTSYS;
>> +	}
>>
>>   	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
>>   		err = dvb_frontend_ioctl_properties(file, cmd, parg);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> +1
> This one resolve annoying mythtv-setup output:
> "E FE_GET_INFO ioctl failed (/dev/dvb/adapter0/frontend0)
> eno: No such device (19)"
> http://www.gossamer-threads.com/lists/mythtv/dev/513410
>
> But, there is a new one!
> Just had a little déjà vu :)


Is there anyone caring to review that carefully?

I am quite out with semaphores (up/down_interruptible) and also frontend 
is so complex... I would rather design / write whole dvb-frontend from 
the scratch :] (not doing that as no time).

regards
Antti

-- 
http://palosaari.fi/

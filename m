Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59172 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760254AbZJMRuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 13:50:20 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Tue, 13 Oct 2009 23:19:30 +0530
Subject: RE: [PATCH 2/6] Davinci VPFE Capture: Take i2c adapter id through
 platform data
Message-ID: <19F8576C6E063C45BE387C64729E73940436DB2166@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1255446503-16727-1-git-send-email-hvaibhav@ti.com>
 <4AD49D13.4030505@ru.mvista.com>
In-Reply-To: <4AD49D13.4030505@ru.mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Sergei Shtylyov [mailto:sshtylyov@ru.mvista.com]
> Sent: Tuesday, October 13, 2009 9:00 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; davinci-linux-open-
> source@linux.davincidsp.com
> Subject: Re: [PATCH 2/6] Davinci VPFE Capture: Take i2c adapter id
> through platform data
> 
> Hello.
> 
> hvaibhav@ti.com wrote:
> 
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> > The I2C adapter ID is actually depends on Board and may vary,
> Davinci
> > uses id=1, but in case of AM3517 id=3.
> 
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> [...]
> 
> > diff --git a/include/media/davinci/vpfe_capture.h
> b/include/media/davinci/vpfe_capture.h
> > index e8272d1..f610104 100644
> > --- a/include/media/davinci/vpfe_capture.h
> > +++ b/include/media/davinci/vpfe_capture.h
> > @@ -94,6 +94,8 @@ struct vpfe_subdev_info {
> >  struct vpfe_config {
> >  	/* Number of sub devices connected to vpfe */
> >  	int num_subdevs;
> > +	/*I2c Bus adapter no*/
> 
>     Put spaces after /* and before */, please. Also, it's "I2C", not
> "I2c"...
[Hiremath, Vaibhav] Thanks Sergei for catching this typo mistake.

I will update and post it again.

Thanks,
Vaibhav

> 
> WBR, Sergei


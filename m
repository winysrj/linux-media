Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB10cmqF011608
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 19:38:48 -0500
Received: from mail04.idc.renesas.com (mail.renesas.com [202.234.163.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB10cbkw028272
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 19:38:37 -0500
Date: Mon, 01 Dec 2008 09:38:14 +0900
From: morimoto.kuninori@renesas.com
In-reply-to: <Pine.LNX.4.64.0811281707440.4430@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-id: <uej0s20i1.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
References: <uljvhtzst.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0811281707440.4430@axis700.grange>
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Add ov7725 ov7720 support to ov772x driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Dear Guennadi

Thank you for checking patch.

> > @@ -837,15 +859,16 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
> >  	 */
> >  	pid = i2c_smbus_read_byte_data(priv->client, PID);
> >  	ver = i2c_smbus_read_byte_data(priv->client, VER);
> > -	if (pid != 0x77 ||
> > -	    ver != 0x21) {
> > +	if (pid != GET_PID(priv->id->driver_data) ||
> > +	    ver != GET_VER(priv->id->driver_data)) {
> >  		dev_err(&icd->dev,
> >  			"Product ID error %x:%x\n", pid, ver);
> >  		return -ENODEV;
> >  	}
> 
> this means, you can indeed probe the exact type of the camera - 7720 vs. 
> 7725, right? Then why do you require the platform code to also specify 
> exactly which camera is connected? Why don't you leave the platform code 
> at the old requirement, i.e., it should just register an i2c device of 
> type "ov772x" and then detect yourself what exactly sensor is there? This 
> is what I've done in mt9m001 and mt9v022. They both support several sensor 
> variants too. This way you can use one kernel for all compatible cameras. 
> If there is no real reason not to do the same in ov772x, I would suggest 
> you switch it over to autoprobing.

Indeed, it is not necessary to specify it accurately.
Sorry about it.

Therefore I would like to re-create this patch.
But how should I do about v4l2-chip-ident.h ?

only V4L2_IDENT_OV772X is better ?
or should I add new V4L2_IDENT_OV7720 and V4L2_IDENT_OV7725 ?

If the answer is latter, should I send 2 patches ?

Best regards
/Morimoto

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G6OlAH029160
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:24:47 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9G6OZi9022210
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:24:35 -0400
Date: Thu, 16 Oct 2008 08:24:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <aec7e5c30810151921v53ab947aq8e1dd6c6ee834eaa@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810160814190.3892@axis700.grange>
References: <uskqyqg58.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0810160041250.8535@axis700.grange>
	<aec7e5c30810151921v53ab947aq8e1dd6c6ee834eaa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add ov772x driver
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

Hi Magnus

On Thu, 16 Oct 2008, Magnus Damm wrote:

> >> +     /*
> >> +      * color bar mode
> >> +      */
> >> +     if (priv->info->color_bar) {
> >> +             ret = ov772x_mask_set(priv->client,
> >> +                             DSP_CTRL3, CBAR_MASK  , CBAR_ON);
> >> +             if (ret < 0)
> >> +                     goto start_end;
> >> +     }
> >
> > What is this "color bar mode" and why do you think you need it to be
> > specified by the platform data (also see below)?
> 
> The color bar mode is a camera test mode where color bars similar to
> the vivi driver are output instead of the camera image. It's very
> useful for testing and getting byte order issues resolved. Ideally I'd
> like to have it as a second output, but I have to extend the SoC
> camera framework first to get that in place.
> 
> I'm not sure if platform data is the best place to enable this, but I
> guess it's good enough.

Hm, so, to test your camera you have to modify your source and rebuild 
your kernel... And same again to switch back to normal operation. Does not 
sound very convenient to me. OTOH, making it a module parameter makes it 
much easier. In fact, maybe it would be a good idea to add a new 
camera-class control for this mode. Yet another possibility is to enable 
debug register-access in the driver and use that to manually set the test 
mode from user-space. A new v4l-control seems best to me, not sure what 
others will say about this. As you probably know, many other cameras also 
have this "test pattern" mode, some even several of them. So, this becomes 
a control with a parameter then.

> > Now, this one. Please, use struct soc_camera_link. It also provides bus_id
> > (your iface), power, ok, I admit, the inclusion of the "gpio" member in it
> > was a mistake of mine, it is too specific, we might remove it at some
> > point. I am not sure you really need color_bar and bus_width. I think,
> > cameras are more or less exchangeable parts, and if they need some
> > parameters, that cannot be autoprobed and do not belong to the camera
> > itself, it might be better to make them module parameters, like the
> > sensor_type parameter in mt9v022. Even if in your case the sensor chip is
> > soldered on the board, in another configuration it might not be.
> 
> Using soc_camera_link sounds like a good idea. I don't agree with you
> regarding the module parameters - doing that removes the
> per-camera-instance configuration that the platform data gives us.

Then a new control or raw register access would be a better way, I think.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

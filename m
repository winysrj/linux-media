Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32702.mail.mud.yahoo.com ([68.142.207.246]:32681 "HELO
	web32702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751868Ab0AZCvS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 21:51:18 -0500
Message-ID: <937726.9285.qm@web32702.mail.mud.yahoo.com>
Date: Mon, 25 Jan 2010 18:51:16 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Re: [Patch 3/3] Kworld 315U
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
In-Reply-To: <4B5DA71B.5010701@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do you need me to resubmit the patches as a file attachment? 

Thanks,
Franklin Meng

--- On Mon, 1/25/10, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> Subject: Re: [Patch 3/3] Kworld 315U
> To: "Franklin Meng" <fmeng2002@yahoo.com>
> Cc: linux-media@vger.kernel.org, "Douglas Schilling Landgraf" <dougsland@gmail.com>
> Date: Monday, January 25, 2010, 6:13 AM
> Franklin Meng wrote:
> 
> Also complained about line-wrapping.
> 
> Cheers,
> Mauro
> > Patch to bring device out of power saving mode. 
> 
> >  
> > Signed-off-by: Franklin Meng<fmeng2002@yahoo.com>
> > 
> > diff -r b6b82258cf5e
> linux/drivers/media/video/em28xx/em28xx-core.c   
>            
>    
> > ---
> a/linux/drivers/media/video/em28xx/em28xx-core.c 
>   Thu Dec 31 19:14:54 2009 -0200
> > +++
> b/linux/drivers/media/video/em28xx/em28xx-core.c 
>   Sun Jan 17 22:54:21 2010 -0800
> > @@ -1132,6 +1132,7 @@       
>                
>                
>                
>          
> >   */         
>                
>                
>                
>                
>         
> >  void em28xx_wake_i2c(struct em28xx *dev) 
>                
>                
>            
> >  {           
>                
>                
>                
>                
>         
> > +   
>    v4l2_device_call_all(&dev->v4l2_dev,
> 0, core,  s_power, 1);       
>            
> >     
>    v4l2_device_call_all(&dev->v4l2_dev,
> 0, core,  reset, 0);         
>            
> >     
>    v4l2_device_call_all(&dev->v4l2_dev,
> 0, video, s_routing,         
>            
> >               
>      
>    INPUT(dev->ctl_input)->vmux, 0,
> 0);               
>            
> > 
> > 
> > 
> > 
> >       
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


      

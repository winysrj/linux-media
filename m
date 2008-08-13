Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7DHCbme007230
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 13:12:37 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7DHCOuk009618
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 13:12:25 -0400
Date: Wed, 13 Aug 2008 19:12:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87hc9o6eks.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0808131911330.7713@axis700.grange>
References: <87hca34ra0.fsf@free.fr>
	<Pine.LNX.4.64.0808022146090.27474@axis700.grange>
	<873alnt2bh.fsf@free.fr>
	<Pine.LNX.4.64.0808121612330.8089@axis700.grange>
	<1218616667.48a29d5bcb7ea@imp.free.fr>
	<Pine.LNX.4.64.0808131105020.3884@axis700.grange>
	<1218621820.48a2b17c963cd@imp.free.fr>
	<Pine.LNX.4.64.0808131322340.3884@axis700.grange>
	<87skt86fb9.fsf@free.fr>
	<Pine.LNX.4.64.0808131845200.7458@axis700.grange>
	<87hc9o6eks.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: style cleanup
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

On Wed, 13 Aug 2008, Robert Jarzmik wrote:

> The correct behaviour would be something like :
> 
> @@ -778,15 +776,13 @@ static int mt9m111_init(struct soc_camera_device *icd)
>  
>  	mt9m111->context = HIGHPOWER;
>  	ret = mt9m111_enable(icd);
> -	if (ret >= 0)
> +	if (!ret)
>  		ret = mt9m111_reset(icd);
> -	if (ret >= 0)
> +	if (!ret)
>  		ret = mt9m111_set_context(icd, mt9m111->context);
> -	if (ret >= 0)
> +	if (!ret)
>  		ret = mt9m111_set_autoexposure(icd, mt9m111->autoexposure);
> -	if (ret < 0)
> +	if (ret)
>  		dev_err(&icd->dev, "mt9m111 init failed: %d\n", ret);
> -	return ret ? -EIO : 0;
> +	return ret;
>  }

And in mt9m111_resume()? Do you want to check return codes of each 
function there too?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

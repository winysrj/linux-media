Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7DGcWNx011130
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 12:38:32 -0400
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7DGcKBW017352
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 12:38:21 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <87hca34ra0.fsf@free.fr>
	<Pine.LNX.4.64.0808022146090.27474@axis700.grange>
	<873alnt2bh.fsf@free.fr>
	<Pine.LNX.4.64.0808121612330.8089@axis700.grange>
	<1218616667.48a29d5bcb7ea@imp.free.fr>
	<Pine.LNX.4.64.0808131105020.3884@axis700.grange>
	<1218621820.48a2b17c963cd@imp.free.fr>
	<Pine.LNX.4.64.0808131322340.3884@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 13 Aug 2008 18:38:18 +0200
In-Reply-To: <Pine.LNX.4.64.0808131322340.3884@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed\,
	13 Aug 2008 13\:35\:19 +0200 \(CEST\)")
Message-ID: <87skt86fb9.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Fix a typo in Kconfig, simplify error checking, further minor cleanup.
>
> Signed-off-by: Guennadi Liakhovetski <g.iakhovetski@gmx.de>
Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>

But ...

> @@ -778,15 +776,13 @@ static int mt9m111_init(struct soc_camera_device *icd)
>  
>  	mt9m111->context = HIGHPOWER;
>  	ret = mt9m111_enable(icd);
> -	if (ret >= 0)
> +	if (!ret) {
>  		mt9m111_reset(icd);
> -	if (ret >= 0)
>  		mt9m111_set_context(icd, mt9m111->context);
> -	if (ret >= 0)
>  		mt9m111_set_autoexposure(icd, mt9m111->autoexposure);
> -	if (ret < 0)
> +	} else
>  		dev_err(&icd->dev, "mt9m111 init failed: %d\n", ret);
> -	return ret ? -EIO : 0;
> +	return ret;
>  }
You changed the fault path here : you don't check if every call succeeds. I
don't think it's very important though ... I certainly don't care that much.

Plus one style issue : IIRC, if there are braces on the if statement, there must
be braces on the else statement, even if it's a one line else block =>
+	} else {
 		dev_err(&icd->dev, "mt9m111 init failed: %d\n", ret);
+	}

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

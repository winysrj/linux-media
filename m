Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAI9FQR006448
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 13:09:15 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAAI9BH8007892
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 13:09:12 -0500
Received: by ug-out-1314.google.com with SMTP id j30so454709ugc.13
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 10:09:11 -0800 (PST)
Message-ID: <30353c3d0811101009u195fb42du346ff3e0fb559b19@mail.gmail.com>
Date: Mon, 10 Nov 2008 13:09:11 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0811101335170.4248@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
	<Pine.LNX.4.64.0811101335170.4248@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 5/5] pxa-camera: framework to handle camera-native and
	synthesized formats
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

[snip]
> +static bool depth_supported(struct soc_camera_device *icd, int i)
> +{
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       struct pxa_camera_dev *pcdev = ici->priv;
> +
> +       switch (icd->formats[i].depth) {
> +       case 8:
> +               if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
> +                       return true;
> +               return false;
I'm not sure what the linux kernel development docs might say about
this, but the if statement here might be unnecessary. Couldn't you
write the following instead?

return pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8;

> +       case 9:
> +               if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_9)
> +                       return true;
> +               return false;
> +       case 10:
> +               if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_10)
> +                       return true;
> +               return false;
> +       }
> +       return false;
> +}

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

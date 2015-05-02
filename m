Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx17lb.world4you.com ([81.19.149.127]:40213 "EHLO
	mx17lb.world4you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbEBHTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2015 03:19:13 -0400
Received: from [91.119.82.180] (helo=tomcom)
	by mx17lb.world4you.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <treitmayr@devbase.at>)
	id 1YoRhf-0001po-IA
	for linux-media@vger.kernel.org; Sat, 02 May 2015 09:19:11 +0200
Message-ID: <1430551151.29019.6.camel@devbase.at>
Subject: Re: [PATCH] media: Fix regression in some more dib0700 based
 devices.
From: Thomas Reitmayr <treitmayr@devbase.at>
To: linux-media@vger.kernel.org
Date: Sat, 02 May 2015 09:19:11 +0200
In-Reply-To: <1430522284-9138-1-git-send-email-treitmayr@devbase.at>
References: <1430522284-9138-1-git-send-email-treitmayr@devbase.at>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
as indicated by the "Fixes:" commit, this problem exists from kernel
version 3.17 up until now. Please consider forwarding the fix to
linux-stable if it looks ok to you.
Best regards,
-Thomas


Am Samstag, den 02.05.2015, 01:18 +0200 schrieb Thomas Reitmayr:
> Fix an oops during device initialization by correctly setting size_of_priv
> instead of leaving it 0.
> The regression was introduced by 8abe4a0a3f6d4217b16a ("[media] dib7000:
> export just one symbol") and only fixed for one type of dib0700 based
> devices in 9e334c75642b6e5bfb95 ("[media] Fix regression in some dib0700
> based devices").
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=92301
> 
> Fixes: 8abe4a0a3f6d4217b16a ("[media] dib7000: export just one symbol")
> Signed-off-by: Thomas Reitmayr <treitmayr@devbase.at>
> ---
>  drivers/media/usb/dvb-usb/dib0700_devices.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
> index 90cee38..e87ce83 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
> @@ -3944,6 +3944,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  
>  				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
>  			}},
> +				.size_of_priv = sizeof(struct
> +						dib0700_adapter_state),
>  			}, {
>  			.num_frontends = 1,
>  			.fe = {{
> @@ -3956,6 +3958,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  
>  				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
>  			}},
> +				.size_of_priv = sizeof(struct
> +						dib0700_adapter_state),
>  			}
>  		},
>  
> @@ -4009,6 +4013,8 @@ struct dvb_usb_device_properties dib0700_devices[] = {
>  
>  				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
>  			}},
> +				.size_of_priv = sizeof(struct
> +						dib0700_adapter_state),
>  			},
>  		},
>  


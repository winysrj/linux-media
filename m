Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58969 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaIXWcS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:32:18 -0400
Message-ID: <54234664.3030500@iki.fi>
Date: Thu, 25 Sep 2014 01:32:04 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH 09/18] [media] cx88: remove return after BUG()
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com> <9558d5ca24c16761b267ac700661aeaa501f1b1e.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <9558d5ca24c16761b267ac700661aeaa501f1b1e.1411597610.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Are these even cases you should use BUG()? How about WARN()...

Antti

On 09/25/2014 01:27 AM, Mauro Carvalho Chehab wrote:
> As reported by smatch:
>
> drivers/media/pci/cx88/cx88-video.c:699 get_queue() info: ignoring unreachable code.
> drivers/media/pci/cx88/cx88-video.c:714 get_resource() info: ignoring unreachable code.
> drivers/media/pci/cx88/cx88-video.c:815 video_read() info: ignoring unreachable code.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
> index ed8cb9037b6f..ce27e6d4f16e 100644
> --- a/drivers/media/pci/cx88/cx88-video.c
> +++ b/drivers/media/pci/cx88/cx88-video.c
> @@ -696,7 +696,6 @@ static struct videobuf_queue *get_queue(struct file *file)
>   		return &fh->vbiq;
>   	default:
>   		BUG();
> -		return NULL;
>   	}
>   }
>
> @@ -711,7 +710,6 @@ static int get_resource(struct file *file)
>   		return RESOURCE_VBI;
>   	default:
>   		BUG();
> -		return 0;
>   	}
>   }
>
> @@ -812,7 +810,6 @@ video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
>   					    file->f_flags & O_NONBLOCK);
>   	default:
>   		BUG();
> -		return 0;
>   	}
>   }
>
>

-- 
http://palosaari.fi/

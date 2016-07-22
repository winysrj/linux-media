Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:40902 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbcGVO15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 10:27:57 -0400
Subject: Re: [PATCH] [media] Documentation: Fix V4L2_CTRL_FLAG_VOLATILE
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org
References: <1469196454-1396-1-git-send-email-ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ecb2e5b2-3255-e564-b456-8acdf297813b@xs4all.nl>
Date: Fri, 22 Jul 2016 16:27:51 +0200
MIME-Version: 1.0
In-Reply-To: <1469196454-1396-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/22/2016 04:07 PM, Ricardo Ribalda Delgado wrote:
> V4L2_CTRL_FLAG_VOLATILE behaviour when V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
> is set was not properly explained.
> 
> Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
> Credit-to: Hans Verkuil <hansverk@cisco.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-queryctrl.rst | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> index 8d6e61a7284d..3a30d6cf70b4 100644
> --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> @@ -728,10 +728,10 @@ See also the examples in :ref:`control`.
>  	  case the hardware calculates the gain value based on the lighting
>  	  conditions which can change over time.
>  
> -	  .. note:: Setting a new value for a volatile control will have no
> -	     effect and no ``V4L2_EVENT_CTRL_CH_VALUE`` will be sent, unless
> -	     the ``V4L2_CTRL_FLAG_EXECUTE_ON_WRITE`` flag (see below) is
> -	     also set. Otherwise the new value will just be ignored.
> +	  .. note:: Setting a new value for a volatile control will be ignored
> +             unless `V4L2_CTRL_FLAG_EXECUTE_ON_WRITE`` flag (see below) is also set.

That should start with `` not ` (i.e. a double ` instead of a single `).

> +             Setting a new value for a volatile contol will never trigger a

s/contol/control/

Also emphasize 'never':

s/never/*never*/

> +             ``V4L2_EVENT_CTRL_CH_VALUE`` event.
>  
>      -  .. row 9
>  
> 

Regards,

	Hans

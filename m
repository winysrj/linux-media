Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:53510 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122AbbBQOxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 09:53:07 -0500
Message-ID: <54E355BC.9070803@xs4all.nl>
Date: Tue, 17 Feb 2015 15:52:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Arun Kumar K <arun.kk@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media/Documentation: Volatile writable
References: <1424184090-14945-1-git-send-email-ricardo.ribalda@gmail.com> <1424184090-14945-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1424184090-14945-2-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/17/2015 03:41 PM, Ricardo Ribalda Delgado wrote:
> Volatile variables are also writable now. Update the documentation
> accordingly.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  Documentation/DocBook/media/v4l/vidioc-dqevent.xml   | 7 ++++---
>  Documentation/DocBook/media/v4l/vidioc-queryctrl.xml | 6 ++++--
>  Documentation/video4linux/v4l2-controls.txt          | 4 +++-
>  3 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> index b036f89..38d907e 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> @@ -318,9 +318,10 @@
>  	    <entry><constant>V4L2_EVENT_CTRL_CH_VALUE</constant></entry>
>  	    <entry>0x0001</entry>
>  	    <entry>This control event was triggered because the value of the control
> -		changed. Special case: if a button control is pressed, then this
> -		event is sent as well, even though there is not explicit value
> -		associated with a button control.</entry>
> +		changed. Special cases: Volatile controls do no generate this event;

Volatile -> volatile
no -> not
event; -> event.

> +		If a button control is pressed, then this event is sent as well,
> +		even though there is not explicit value associated with a button

Hmm: not -> no

:-)

> +		control.</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>V4L2_EVENT_CTRL_CH_FLAGS</constant></entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> index 2bd98fd..6e1e98d 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
> @@ -599,8 +599,10 @@ writing a value will cause the device to carry out a given action
>  	    <entry>This control is volatile, which means that the value of the control
>  changes continuously. A typical example would be the current gain value if the device
>  is in auto-gain mode. In such a case the hardware calculates the gain value based on
> -the lighting conditions which can change over time. Note that setting a new value for
> -a volatile control will have no effect. The new value will just be ignored.</entry>
> +the lighting conditions which can change over time. Another example would be an error
> +flag (missed trigger, invalid voltage on the sensor). In those situations the user
> +could write to the control to acknowledge the error, but that write will never
> +generate a <constant>V4L2_EVENT_CTRL_CH_VALUE</constant> event.<entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>V4L2_CTRL_FLAG_HAS_PAYLOAD</constant></entry>
> diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
> index 0f84ce8..5517db6 100644
> --- a/Documentation/video4linux/v4l2-controls.txt
> +++ b/Documentation/video4linux/v4l2-controls.txt
> @@ -344,7 +344,9 @@ implement g_volatile_ctrl like this:
>  	}
>  
>  Note that you use the 'new value' union as well in g_volatile_ctrl. In general
> -controls that need to implement g_volatile_ctrl are read-only controls.
> +controls that need to implement g_volatile_ctrl are read-only controls. If they
> +are not, a V4L2_EVENT_CTRL_CH_VALUE will not be generated when the control
> +changes.
>  
>  To mark a control as volatile you have to set V4L2_CTRL_FLAG_VOLATILE:
>  
> 

With those typo fixes:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

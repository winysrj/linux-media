Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2315 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2JIPZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 11:25:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH] qv4l2: avoid empty titles for the video control tabs
Date: Tue, 9 Oct 2012 17:24:56 +0200
Cc: linux-media@vger.kernel.org
References: <1349793964-22825-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1349793964-22825-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201210091724.56456.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue October 9 2012 16:46:04 Frank Schäfer wrote:
> The video control class names are used as titles for the GUI-tabs.
> The current code relies on the driver enumerating the control classes
> properly when using V4L2_CTRL_FLAG_NEXT_CTRL.
> But the UVC-driver (and likely others, too) don't do that, so we can end
> up with an empty class name string.
> 
> Make sure we always have a control class title:
> If the driver didn't enumrate a class along with the controls, call
> VIDIOC_QUERYCTRL for the class explicitly.
> If that fails, fall back to an internal string list.

NACK.

qv4l2 is for testing drivers, so I *want* to see if a driver doesn't provide
the control class name. They really should provide it, and it is not something
that should be papered over.

Regards,

	Hans

> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  utils/qv4l2/ctrl-tab.cpp |   15 ++++++++++++++-
>  utils/qv4l2/v4l2-api.cpp |   25 +++++++++++++++++++++++++
>  utils/qv4l2/v4l2-api.h   |    3 +++
>  3 files changed, 42 insertions(+), 1 deletions(-)
> 
> diff --git a/utils/qv4l2/ctrl-tab.cpp b/utils/qv4l2/ctrl-tab.cpp
> index 5bafbbd..6a4b630 100644
> --- a/utils/qv4l2/ctrl-tab.cpp
> +++ b/utils/qv4l2/ctrl-tab.cpp
> @@ -133,7 +133,20 @@ void ApplicationWindow::addTabs()
>  		m_col = m_row = 0;
>  		m_cols = 4;
>  
> -		const v4l2_queryctrl &qctrl = m_ctrlMap[id];
> +		v4l2_queryctrl &qctrl = m_ctrlMap[id];
> +		/* No real control, it's just the control class description.
> +		   Verify that the driver did enumerate the class properly 
> +		   and add the class name if missing */
> +		if (!strlen((char *)qctrl.name))
> +		{
> +			/* Try to request control class name from API */
> +			qctrl.id = id;
> +			qctrl.type = V4L2_CTRL_TYPE_CTRL_CLASS;
> +			if (!queryctrl(qctrl) || !strlen((char *)qctrl.name))
> +				/* Fall back to a local string list */
> +				strcpy((char *)qctrl.name, ctrl_class_name(ctrl_class).toAscii());
> +		}
> +
>  		QWidget *t = new QWidget(m_tabs);
>  		QVBoxLayout *vbox = new QVBoxLayout(t);
>  		QWidget *w = new QWidget(t);
> diff --git a/utils/qv4l2/v4l2-api.cpp b/utils/qv4l2/v4l2-api.cpp
> index 86cf388..5811cd7 100644
> --- a/utils/qv4l2/v4l2-api.cpp
> +++ b/utils/qv4l2/v4l2-api.cpp
> @@ -638,3 +638,28 @@ bool v4l2::get_interval(v4l2_fract &interval)
>  
>  	return false;
>  }
> +
> +QString v4l2::ctrl_class_name(__u32 ctrl_class)
> +{
> +	switch (ctrl_class) {
> +	case V4L2_CTRL_CLASS_USER:
> +		return "User Controls";
> +	case V4L2_CTRL_CLASS_MPEG:
> +		return "MPEG-compression Controls";
> +	case V4L2_CTRL_CLASS_CAMERA:
> +		return "Camera Controls";
> +	case V4L2_CTRL_CLASS_FM_TX:
> +		return "FM Transmitter Controls";
> +	case V4L2_CTRL_CLASS_FLASH:
> +		return "Flash Device Controls";
> +	case V4L2_CTRL_CLASS_JPEG:
> +		return "JPEG-compression Controls";
> +	case V4L2_CTRL_CLASS_IMAGE_SOURCE:
> +		return "Image Source Controls";
> +	case V4L2_CTRL_CLASS_IMAGE_PROC:
> +		return "Image Processing Controls";
> +	case V4L2_CTRL_CLASS_DV:
> +		return "Digital Video Controls";
> +	}
> +	return "Controls (unknown class)";
> +}
> diff --git a/utils/qv4l2/v4l2-api.h b/utils/qv4l2/v4l2-api.h
> index 4c10466..74e69a8 100644
> --- a/utils/qv4l2/v4l2-api.h
> +++ b/utils/qv4l2/v4l2-api.h
> @@ -163,6 +163,9 @@ public:
>  
>  	bool set_interval(v4l2_fract interval);
>  	bool get_interval(v4l2_fract &interval);
> +
> +	QString ctrl_class_name(__u32 ctrl_class);
> +
>  private:
>  	void clear() { error(QString()); }
>  
> 

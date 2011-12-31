Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40995 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1LaMAb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:00:31 -0500
Date: Sat, 31 Dec 2011 14:00:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 1/5] v4l: Convert V4L2_CID_FOCUS_AUTO control to a
 menu control
Message-ID: <20111231120025.GD3677@valkosipuli.localdomain>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
 <1323011776-15967-2-git-send-email-snjw23@gmail.com>
 <20111210103344.GF1967@valkosipuli.localdomain>
 <4EE36FE1.1080601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE36FE1.1080601@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Apologies for my late answer.

On Sat, Dec 10, 2011 at 03:42:41PM +0100, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 12/10/2011 11:33 AM, Sakari Ailus wrote:
> > On Sun, Dec 04, 2011 at 04:16:12PM +0100, Sylwester Nawrocki wrote:
> >> Change the V4L2_CID_FOCUS_AUTO control type from boolean to a menu
> >> type. In case of boolean control we had values 0 and 1 corresponding
> >> to manual and automatic focus respectively.
> >>
> >> The V4L2_CID_FOCUS_AUTO menu control has currently following items:
> >>   0 - V4L2_FOCUS_MANUAL,
> >>   1 - V4L2_FOCUS_AUTO,
> >>   2 - V4L2_FOCUS_AUTO_MACRO,
> >>   3 - V4L2_FOCUS_AUTO_CONTINUOUS.
> > 
> > I would put the macro mode to a separate menu since it's configuration for
> > how the regular AF works rather than really different mode.
> 
> Yes, makes sense. Most likely there could be also continuous macro auto focus..
> I don't have yet an idea what could be a name for that new menu though.

V4L2_CID_FOCUS_AUTO_DISTANCE? It could then have choices FULL or MACRO.

> Many Samsung devices have also something like guided auto focus, where the
> application can specify location in the frame for focusing on. IIRC this could
> be also single-shot or continuous. So it could make sense to group MACRO and
> "guided" auto focus in one menu, what do you think ?

I think it could be a separate menu. It's not connected to the distance
parameter. We also need to discuss how the af statistics window
configuration is done. I'm not certain there could even be a standardised
interface which could be used to control it all.

> >> @@ -567,6 +576,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> >>  	case V4L2_CID_PRIVACY:			return "Privacy";
> >>  	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
> >>  	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
> >> +	case V4L2_CID_DO_AUTO_FOCUS:		return "Do Auto Focus";
> > 
> > I'd perhaps use "begin" or "start". How does the user learn the autofocus
> 
> I agree, it's not something than is finished after G_CTRL call returns.
> 
> V4L2_CID_START_AUTO_FOCUS sounds better to me.
> 
> > has finished? I think this looks like quite similar problem than telling the
> > flash strobe status to the user. The solution could also be similar to that.
> 
> I guess you're suggesting an auto focus status control? Together with the control
> events it would be nice interface for notifying the applications.

I agree.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

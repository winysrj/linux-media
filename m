Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39749 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1L3SmR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 13:42:17 -0500
Date: Fri, 30 Dec 2011 20:42:12 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: Hans de Goede <hdegoede@redhat.com>
Cc: "HeungJun, Kim" <riverful.kim@samsung.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Sylwester Nawrocki' <snjw23@gmail.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu
 control
Message-ID: <20111230184212.GW3677@valkosipuli.localdomain>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <1325053428-2626-2-git-send-email-riverful.kim@samsung.com>
 <4EFB1B04.6060305@gmail.com>
 <201112281451.39399.laurent.pinchart@ideasonboard.com>
 <20111229233406.GU3677@valkosipuli.localdomain>
 <000801ccc6bd$4b844520$e28ccf60$%kim@samsung.com>
 <4EFD7955.8070603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFD7955.8070603@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Dec 30, 2011 at 09:41:57AM +0100, Hans de Goede wrote:
...
> Right, so the above is exactly why I ended up making the pwc whitebalance
> control the way it is, the user can essentially choice between a number
> of options:
> 1) auto whitebal
> 2) a number of preset whitebal values (seems your proposal has some more then the pwc
>    driver, which is fine)
> 3) manual whitebal, at which point the user may set whitebal through one of:
>    a) a color temperature control
>    b) red and blue balance controls
>    c) red, green and blue gains

d) red, green, blue and... another green. This is how some raw bayer sensors
can be controlled.

> Notice that we also need to add some standardized controls for the 3c case, but that
> is a different discussion.

I was planning to add the gain to low-level controls once the other  sensor
controls have been properly discussed, and hopefully approved, first.

> Seeing how this discussion has evolved I believe that what I did in the pwc driver
> is actually right from the user pov, the user gets one simple menu control which
> allows the user to choice between auto / preset 1 - x / manual and since as
> described above choosing one of the options excludes the other options from being
> active I believe having this all in one control is the right thing to do.

I still think automatic white balance should be separate from the rest, as
it currently is (V4L2_CID_AUTO_WHITE_BALANCE). If such presets aren't
available, the way the user would enable automatic white balance changes,
which is bad.

Also the automatic white balance algorithms may have related controls, which
would bring back the same situatio of some controls not being active at all
times --- which I don't see as a problem at all.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk

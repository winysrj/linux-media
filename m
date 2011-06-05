Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41724 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab1FENIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jun 2011 09:08:52 -0400
Date: Sun, 5 Jun 2011 16:08:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Kim, HeungJun" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v9] Add support for M-5MOLS 8 Mega Pixel camera ISP
Message-ID: <20110605130847.GF6073@valkosipuli.localdomain>
References: <1305507806-10692-1-git-send-email-riverful.kim@samsung.com>
 <4DDDFD6F.9000601@samsung.com>
 <20110605115529.GC6073@valkosipuli.localdomain>
 <201106051411.15067.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106051411.15067.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Sun, Jun 05, 2011 at 02:11:14PM +0200, Hans Verkuil wrote:
> On Sunday, June 05, 2011 13:55:30 Sakari Ailus wrote:
> > On Thu, May 26, 2011 at 04:12:47PM +0900, Kim, HeungJun wrote:
> > > >> +
> > > >> +	struct v4l2_ctrl_handler handle;
> > > >> +	/* Autoexposure/exposure control cluster */
> > > >> +	struct {
> > > >> +		struct v4l2_ctrl *autoexposure;
> > > >> +		struct v4l2_ctrl *exposure;
> > > >> +	};
> > > > 
> > > > Would it be different without the anonymous struct?
> > > These two v4l2_ctrl is clustered. So, anonymous struct should be used
> > > for v4l2_ctrl_cluster().
> > 
> > It makes no difference in how the pointers are arranged in the memory.
> 
> The reason I use an anonymous struct for control clusters is that they
> nicely highlight that these two pointers belong together.
> 
> You don't need to do this, of course, but in that case you have to clearly
> group such pointers using comment(s). Alternatively, you can use a pointer
> array, but that's a pain in the ass to use in practice.
> 
> So the sole purpose of the anonymous struct is to visually group the pointers
> without making it harder to access them.
> 
> It is debatable whether it is needed if you have only one cluster. But when
> you have more than one cluster this approach is very effective.

This is fine for me as well.

-- 
Sakari Ailus
sakari dot ailus at iki dot fi

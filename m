Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34104 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab1DFNXV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 09:23:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC v2] V4L2 API for flash devices
Date: Wed, 6 Apr 2011 15:23:19 +0200
Cc: Nayden Kanchev <nkanchev@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Kim HeungJun <riverful@gmail.com>
References: <4D9C2000.9090500@maxwell.research.nokia.com> <4D9C2670.2000603@mm-sol.com> <4D9C31A4.3050705@maxwell.research.nokia.com>
In-Reply-To: <4D9C31A4.3050705@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104061523.19756.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Wednesday 06 April 2011 11:25:56 Sakari Ailus wrote:
> Nayden Kanchev wrote:
> > On 04/06/2011 11:10 AM, Sakari Ailus wrote:
> >> - Added an open question on a new control:
> >> V4L2_CID_FLASH_EXTERNAL_STROBE_WHENCE.
> > 
> > <snip>
> > 
> >> 2. External strobe edge / level
> >> -------------------------------
> >> 
> >> No use is seen currently for this, but it may well appear, and the
> >> hardware supports this. Level based trigger should be used since it is
> >> more precise.
> >> 
> >>     V4L2_CID_FLASH_EXTERNAL_STROBE_WHENCE
> >> 
> >> Whether the flash controller considers external strobe as edge, when the
> >> only limit of the strobe is the timeout on flash controller, or level,
> >> when the flash strobe will last as long as the strobe signal, or as long
> >> until the timeout expires.
> >> 
> >> enum v4l2_flash_external_strobe_whence {
> >> 
> >>     V4L2_CID_FLASH_EXTERNAL_STROBE_LEVEL,
> >>     V4L2_CID_FLASH_EXTERNAL_STROBE_EDGE,
> >> 
> >> };
> 
> Removed "CID_":
> 
> enum v4l2_flash_external_strobe_whence {
> 	V4L2_FLASH_EXTERNAL_STROBE_LEVEL,
> 	V4L2_FLASH_EXTERNAL_STROBE_EDGE,
> };
> 
> I guess this should be an rw menu control for LED flash?
> 
> > I agree that control over the strobe usage (level/edge) is required.
> > Although we have some bad experience will lack of detailed information
> > how exactly the flash chip will use those signals.
> > 
> > For example with AS3645A flash driver strobing by edge produced really
> > strange flash output - light intensity was changing during the process
> > and flash was stopped before the HW timeout.
> > 
> > On the other hand strobing by level didn't cause problems.
> > 
> > So even if HW supports some functionally we should prevent such
> > malfunctioning by adding some restrictions in the board code also.
> 
> I agree.
> 
> The control should be probably exposed to tell which kind of
> functionality does the flash chip provide, even if the menu has just one
> option in it.
> 
> > I would also rename xxx_STROBE_WHENCE to xxx_STROBE_TYPE but it is just
> > a suggestion :)
> 
> Sounds good to me.
> 
> V4L2_CID_FLASH_STROBE_MODE should be renamed to
> V4L2_CID_FLASH_STROBE_WHENCE. That proper use of whence IMO. :-)

Does this really need to be exposed to userspace ? Shouldn't it just be static 
information coming from platform data ?

-- 
Regards,

Laurent Pinchart

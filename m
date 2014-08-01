Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:21669 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbaHAPUF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 11:20:05 -0400
Date: Fri, 1 Aug 2014 17:19:57 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv1 02/12] vivid.txt: add documentation for the vivid
 driver.
Message-Id: <20140801171957.fe3359ee5a03f7d512de2027@ao2.it>
In-Reply-To: <53DB6877.1070001@xs4all.nl>
References: <1406730195-64365-1-git-send-email-hverkuil@xs4all.nl>
	<1406730195-64365-3-git-send-email-hverkuil@xs4all.nl>
	<1406834177.1912.25.camel@palomino.walls.org>
	<53DB6877.1070001@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 01 Aug 2014 12:14:15 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On 07/31/2014 09:16 PM, Andy Walls wrote:
> > On Wed, 2014-07-30 at 16:23 +0200, Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
[..]
> >> +- Improve the sinus generation of the SDR radio.
> > 
> > Maybe a lookup table, containing the first quarter wave of cos() from 0
> > to pi/2 in pi/200 steps, and then linear interpolation for cos() of
> > angles in between those steps.  You could go with a larger lookup table
> > with finer grained steps to reduce the approximation errors.  A lookup
> > table with linear interpolation, I would think, requires fewer
> > mutliplies and divides than the current Taylor expansion computation.
> 
> Yeah, I had plans for that. There actually is a sine-table already in vivid-tpg.c
> since I'm using that to implement Hue support.
> 

I don't know what your requirements are here but JFTR there is already a
simplistic implementation of fixed point operations in
include/linux/fixp-arith.h I used them in
drivers/media/usb/gspca/ov534.c for some hue calculation.

Ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41439 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbaJTUQt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 16:16:49 -0400
Date: Mon, 20 Oct 2014 18:16:40 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Michael Ira Krufky <mkrufky@linuxtv.org>,
	Ralph Metzler <rjkm@metzlerbros.de>
Cc: LMML <linux-media@vger.kernel.org>
Subject: DVB new get info ioctl
Message-ID: <20141020181640.2c9e48c4@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

As you know, one of the topics discussed during the last Media Summit were about
writing a new ioctl to replace FE_GET_INFO's fe_caps. 

The summary of our discussions follow bellow:
(mental note: I should put the description below on our mini-summit notes): 

<SUMMIT>
The main issue with fe_caps is that, currently, there are only two bits left, 
between:
	FE_HAS_EXTENDED_CAPS		= 0x800000, 
and
	FE_CAN_MULTISTREAM		= 0x4000000,

And this is not enough to represent the current capabilities of
modern delivery system's frontends.

As a few examples of missing things that we want to be able to
report, we have:

- Some DVB-C2 demods supports automatic symbol rate detection between
  a certain range (Ralph);

- Some devices that only work on "auto" mode, sometimes being even
  unable to return what it was detected, even with the full specs (Ralph).

- Complex delivery systems like ISDB-T have some combinations that
  aren't very common, and some chipset providers decided to not implement
  (Mauro).
  For example, mb86a20s frontend doesn't support guard interval equal to
  1/32[1].

So, the agreeded strategy is to write a new ioctl that, once the delivery
system is set, it will return what are the valid values/ranges that
a given frontend property can support.

In order to optimize the drivers, the core could pre-fill it with all 
that it is supported by a given delivery system, letting the driver to
override it, disabling the features that aren't supported.

Michael proposed to send RFCs for that.
</SUMMIT>

[1] Also, while double checking today at the code, it also doesn't 
    support mode 1 (2K).

That's what it was agreed during the meeting.

After our discussions about a new ioctl that would be able to properly
report the frontend capabilities for new standards, during the Media Summit,
in order to be able to report the currently needs, I did some brainstorming
about that.

It come to me that the fe_caps replacement ioctl should need to 
return not only the valid values/ranges but also a flag that will
indicate if:

- The frontend supports auto-detecting the parameter (CAN_AUTO);
- The frontend allows setting such parameter (CAN_SET) [2];
- The frontend can report the detected parameter (CAN_GET);
- If the valid values comes on ranges (IS_RANGE), to be used by
  parameters like frequency and symbol rate.

Btw, we have a problem with IS_RANGE for symbol rate: There are actually
two ranges there:
	- The supported symbol rate range;
	- The auto-detected symbol rate range.

Perhaps Ralph could shed us a light on it, but my understanding is
that some devices might have a broader supported range than the
one that the frontend can auto-detect.

If so, the solution could be to add an extra property for the
"autodetection symbol rate" range.

[2] ISDB-S new Toshiba demod, for example, doesn't allow setting the
    modulation. This should always be auto-detected via TMCC table.
    Btw, this seems to be a requirement at the spec (but nothing
    prevents some vendor to not implement it).

We've discussed in priv that we might report everything as ranges,
but, on a second taught, I think that we should only use ranges for
numeric values, and not for enums.

Regards,
Mauro

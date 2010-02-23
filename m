Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0BWMKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 07:10:35 -0500
Message-ID: <4B83C5AF.7080002@infradead.org>
Date: Tue, 23 Feb 2010 09:10:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Brandon Philips <brandon@ifup.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories & libv4l
References: <4B55445A.10300@infradead.org> <4B57B6E4.2070500@infradead.org>    <20100121024605.GK4015@jenkins.home.ifup.org>    <201001210834.28112.hverkuil@xs4all.nl> <4B5B30E4.7030909@redhat.com>    <20100222225426.GC4013@jenkins.home.ifup.org>    <4B839687.4090205@redhat.com> <e69623b3a970d166a31af8258040a471.squirrel@webmail.xs4all.nl> <4B839E80.8050607@redhat.com>
In-Reply-To: <4B839E80.8050607@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
>> I would call it media-utils. A nice name and it reflects that it contains
>> both dvb and v4l utilities.
>>
> 
> Well, the judge is still out on also adding the dvb utils to this git repo.
> I'm neutral on that issue, but I will need a co-maintainer for those bits
> if they end up in the new v4l-utils repo too.

I also don't have any strong feeling about merging dvb utils. The advantage is
to share the same release control, but the code is completely separated. There
will likely be some developers working on both projects.

A deeper look on what we have on userspace, there are 3 categories of software:
	- apps that handle /dev/v4l/* devices (e. g. V4L2 API hanling);
	- apps that handle /dev/dvb/* devices (e. g. DVB API handling);
	- apps that handle /dev/input/* devices (e. g. IR API handling).

The last one is, in fact just one code, plus lots of IR tables from all V4L and DVB
drivers. The table is created today by the Makefile: it reads the table from the
kernel source tree and generates the tables for the userspace util [*].

If we are maintaining separate trees for each class of device, it might make sense
to have separate a tree for the IR stuff, but this seems overkill to me, since we'll
need to handle 3 separate version controls for each tool class, and, in practice,
v4l/dvb users will need to get more than one tree to get full control of his device.

So, I prefer to have one tree with all 3 types of utilities.

[*] Btw, how Brandon addressed it with the conversion tool? I think we'll need to add
some tools there to handle the kernel driver <-> v4l2-apps interdependency, e. g.
creating the *.c.xml files needed by the media-specs and importing the IR keymaps from
the driver sources.

-- 

Cheers,
Mauro

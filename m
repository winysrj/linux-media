Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:63460 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaI0K5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Sep 2014 06:57:14 -0400
Received: by mail-la0-f54.google.com with SMTP id ty20so3194746lab.41
        for <linux-media@vger.kernel.org>; Sat, 27 Sep 2014 03:57:12 -0700 (PDT)
Message-ID: <54269807.50109@googlemail.com>
Date: Sat, 27 Sep 2014 12:57:11 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?UTF-8?B?QW5kcsOpIFJvdGg=?= <neolynx@gmail.com>
Subject: Upcoming v4l-utils 1.6.0 release
References: <20140925213820.1bbf43c2@recife.lan>
In-Reply-To: <20140925213820.1bbf43c2@recife.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Mauro was very busy adding Doxygen documentation to libdvbv5. Instead of
cherry picking the (many) individual commits I'd like to release master
as 1.6.0.

Has anyone uncommited pending work? If not I'd like to release on Monday
(29th).

About the DVB API/ABI incompatibility discussed below:

As far as I understand the service_location feature should work but is
an extension to the standard. Does it harm if we keep it until we have
something better in place to handle extensions?

The service list descriptor feature is unimplemented (and thus broken).
Would it help if we return -1 from dvb_desc_service_list_init to reflect
that fact or does it break something else? But I'd keep the symbol in
the library to maintain ABI compatibility.

Is there a reason to expose the individual descriptor functions to the
public API? Aren't dvb_descriptors table and its users enough?

Thanks,
Gregor

On 26/09/14 02:38, Mauro Carvalho Chehab wrote:
> Hi Gregor,
> 
> I'm done with the libdvbv5 API documentation. There are two issues there that
> we should be fixing on a next release:
> 1) one descriptor should likely be removed.
>    It is the one contained at lib/libdvbv5/include/desc_service_location.h
> 
> It is not used anywhere at the code (nor on userspace). I suspect that this
> is wrong, because I was unable to find any documentation about that. It
> looks very similar to an ATSC descriptor. I suspect that this is just
> duplicated (yet, see the comments below).
> 
> 2) one descriptor should have a table fixed or be removed.
>    it is at lib/libdvbv5/include/desc_service_list.h.
> 
> This one have the parsing code commented. This is not that bad, if the
> data structure field needed to store its content weren't also commented.
> 
> Either removing or fixing will break the API/ABI.
> 
> I opted to not add those descriptors at the doxygen documentation. Just
> added the javadoc tags inside their code, with a @bug there.
> 
> So, I think we should try to release 1.4.1 with those changes.
> 
> Please notice that I also added one extra feature at dma-fe-tool: it
> now replaces femon (with is something that people that use to work with
> the legacy dvb-apps generally request).
> 
> Ah, btw if you know who maintains the dtv-scan-tables package on Debian,
> it could be worth to ask him to rebase the package to use the new format.
> The tables there were fully converted to DVBv5 format, and a Makefile
> target was added to generate the tables with the old format.
> 
> Regards,
> Mauro
> 
> 
> Forwarded message:
> 
> Date: Mon, 22 Sep 2014 23:08:35 +0200
> From: André Roth <neolynx@gmail.com>
> To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Subject: Re: Troubles with two descriptor parsers
> 
> 
> On Mon, 22 Sep 2014 13:39:06 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
>> Hi André,
>>
>> I finished to add documentation for the library. There are, however, two
>> issues:
>>
>> 1) I was unable to discover what's this:
>> 	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/commit/?id=dbb24d3a680dc66496e410cb1cab56ef375f1982
>>
>> There is a descriptor like that for ATSC, but didn't find it for DVB.
>> Also, this is not used at descriptors.c.
> 
> this is used as a user extension (0xa1) in DVB-T here. a friend
> implemented it, I need to ask where he got the specs from. It holds GPS
> coordinates of the sending station. not sure whether libdvbv5 should
> implement user extensions as they could vary. 
> we should maybe have an interface for extending the descriptor table ...
>  
>> Is this some left-over?
> 
> kinda, I had planned to implement it in tvd, and maybe show a map with
> the antenna.
> 
>> 2) This is broken:
>> 	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/commit/?id=7ce5581c7504ff03425666e106d198de3475d0e9
>>
>> As the descriptor parser is commented. Why? We can only fix that for a
>> newer version.
> 
> same story I guess. the service list descriptor (0x41) is in the iso
> standard and is maybe used in conjunction with 0xa1.
> 
> I suggest to fix that in the newer version. Please tell me when a newer
> version is planned, so I can reserve some time for that.
> 
> Sorry for the inconvenience,
>  André
> 


Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38099 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaI0LzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Sep 2014 07:55:01 -0400
Date: Sat, 27 Sep 2014 08:54:55 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Subject: Re: Upcoming v4l-utils 1.6.0 release
Message-ID: <20140927085455.5b0baf89@recife.lan>
In-Reply-To: <54269807.50109@googlemail.com>
References: <20140925213820.1bbf43c2@recife.lan>
	<54269807.50109@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 27 Sep 2014 12:57:11 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> Mauro was very busy adding Doxygen documentation to libdvbv5. Instead of
> cherry picking the (many) individual commits I'd like to release master
> as 1.6.0.

Works for me.

> Has anyone uncommited pending work? If not I'd like to release on Monday
> (29th).
> 
> About the DVB API/ABI incompatibility discussed below:
> 
> As far as I understand the service_location feature should work but is
> an extension to the standard. Does it harm if we keep it until we have
> something better in place to handle extensions?

I'm not sure if it works, as the table parser doesn't call that code.
Ok, some library client could use it, but I don't think that this is
actually being used on tvdaemon.

> The service list descriptor feature is unimplemented (and thus broken).
> Would it help if we return -1 from dvb_desc_service_list_init to reflect
> that fact or does it break something else? But I'd keep the symbol in
> the library to maintain ABI compatibility.

The big problem with the service list descriptor is that there's a
field commented on its structure. Once we decide to implement it,
we'll need to uncomment such field or to replace it with something
else. At the moment we do that, we'll be breaking ABI compatibility.

I would actually prefer if we could get rid of those two broken
descriptors on some release, and to re-add them only when they're
actually working.

> Is there a reason to expose the individual descriptor functions to the
> public API? Aren't dvb_descriptors table and its users enough?

That depends on the usecase. For applications like dvbv5 tools,
that only use the library to scan channels and tune, there's no need.

However, if the application wants to do something more fancy, like
parsing the program guide, it will need to look inside the EIT
descriptors, where the program guide is stored.

There's also a feature that André is working to add to tvdaemon and to
the libdvbv5 library. He can comment a little more about his needs.

As far of what I understood, he wants to use the library to produce
a MPEG-TS, probably to generate what is called MPEG remux.

MPEG remux means to be able to create a new MPEG-TS with a subset of 
the elementary streams that are found on the original stream. In other
words, imagine a stream with 6 independent channels multiplexed inside a 
single MPEG-TS (this is common on DVB-C). A remuxed MPEG could contain
just one of those channels.

In order to be able to create a MPEG-TS, the application need to
be able to handle all tables/descriptors required to produce it.

Regards,
Mauro

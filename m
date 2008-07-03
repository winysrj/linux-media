Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63KE86t028412
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 16:14:08 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63KDtqH028797
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 16:13:55 -0400
Message-ID: <486D337A.4060206@free.fr>
Date: Thu, 03 Jul 2008 22:15:54 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <486D2D60.3070801@hhs.nl> <486D30B9.2050800@free.fr>
	<486D3306.7080009@hhs.nl>
In-Reply-To: <486D3306.7080009@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: PATCH: libv
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hans de Goede a écrit :
> Thierry Merle wrote:
>> Hans de Goede a écrit :
>>> Hi All,
>>>
>>> This patch adds support to libv4l for the compressed bayer format
>>> emitted by
>>> pac207 based cams.
>>>
>>> Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
>>>
>>> Regards,
>>>
>>> Hans
>> Applied on http://www.linuxtv.org/hg/~tmerle/v4l2-library
>> Is it necessary to add the emails about license authorizations in the
>> sources?
>
> I dunno IANAL, but within Fedora (where I'm a packager) the guy
> responsible for the legal stuff, in case of license changes always
> wants a "written" (email is ok) permission notice bundled with the
> sources, so I followed this example, we could put the permission
> notices in some other file, but I think its good practice to keep them
> around bundled with the sources. I deliberately put them at the end so
> that with normal editing they don't get in the way.
>
OK if it is mandatory, continue to put it at the closest place from the
concerned source code.
> Actually I'm about to submit a patch to add a permission notice for
> the sn9c10x decompression algorithm as I didn't write that myself.
>
OK
> Regards,
>
> Hans
>
> p.s.
>
> Sorry about the semi missing subject last mail.
>
I corrected it by myself :)

Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

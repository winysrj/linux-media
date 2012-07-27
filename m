Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:39325 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2G0M22 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 08:28:28 -0400
From: Konke Radlow <kradlow@cisco.com>
To: Gregor Jasny <gjasny@googlemail.com>
Subject: Re: [RFC PATCH 0/2] Add support for RDS decoding
Date: Fri, 27 Jul 2012 14:27:39 +0000
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	hdegoede@redhat.com
References: <1343238241-26772-1-git-send-email-kradlow@cisco.com> <50118F6F.8030504@googlemail.com>
In-Reply-To: <50118F6F.8030504@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207271427.40172.kradlow@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yes, I realized too late that the library header file was missing from the 
submitted patch. I created a additional patch and attached it to the [RFC 
PATCH 1/2] thread.

I updated the repository. It should now be based on the most recent version of 
the tree (I used git://git.linuxtv.org/v4l-utils.git as the origin)

changing the condition in the library header from 
> #if __GNUC__ >= 4
> #define LIBV4L_PUBLIC __attribute__ ((visibility("default")))
> #else
> #define LIBV4L_PUBLIC
> #endif

to 
> #if HAVE_VISIBILITY
> #define LIBV4L_PUBLIC __attribute__ ((visibility("default")))
> #else
> #define LIBV4L_PUBLIC
> #endif

causes linker problems for me. The public library functions can no longer be 
found. I cannot figure out why it's working for programs using libv4l2.la but 
not for programs using libv4l2rds.la

greetings,
Konke 

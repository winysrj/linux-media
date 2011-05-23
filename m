Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50409 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab1EWRzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 13:55:43 -0400
Received: by mail-pv0-f174.google.com with SMTP id 12so2656205pvg.19
        for <linux-media@vger.kernel.org>; Mon, 23 May 2011 10:55:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD513F5.8060602@linuxtv.org>
References: <AANLkTinT9oPT9ob3W6pzuvbxr502gAC5N02TOLGr_pLC@mail.gmail.com>
	<4DD29848.6030901@braice.net>
	<BANLkTin6astzASvU6VfDwD2XCRuZToq+RQ@mail.gmail.com>
	<4DD513F5.8060602@linuxtv.org>
Date: Mon, 23 May 2011 10:55:43 -0700
Message-ID: <BANLkTimH6s58t5769UnNyunFXUK-ED4NHw@mail.gmail.com>
Subject: Re: [libdvben50221] [PATCH] Assign same resource_id in
 open_session_response when "resource non-existent"
From: Tomer Barletz <barletz@gmail.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Brice DUBOST <braice@braice.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, May 19, 2011 at 5:58 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
> On 05/18/2011 09:16 PM, Tomer Barletz wrote:
>> On Tue, May 17, 2011 at 8:46 AM, Brice DUBOST <braice@braice.net> wrote:
>>> On 18/01/2011 15:42, Tomer Barletz wrote:
> ...
>
> Can you please resend the patch inline with a proper signed-off-by line,
> in order to get it tracked by patchwork.kernel.org?
>
> Regards,
> Andreas
>

Here's the patch with the signed-off-by line:

Signed-off-by: Tomer Barletz <barletz@gmail.com>
---
diff -r d3509d6e9499 lib/libdvben50221/en50221_stdcam_llci.c
--- a/lib/libdvben50221/en50221_stdcam_llci.c	Sat Aug 08 19:17:21 2009 +0200
+++ b/lib/libdvben50221/en50221_stdcam_llci.c	Tue Jan 18 14:51:34 2011 +0200
@@ -351,6 +351,10 @@
 		}
 	}

+	/* In case the reousrce does not exist, return the same id in the response.
+	   See 7.2.6.2 */
+	*connected_resource_id = requested_resource_id;
+
 	return -1;
 }

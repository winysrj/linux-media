Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59692 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2E0R1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 13:27:43 -0400
Received: by bkcji2 with SMTP id ji2so1716446bkc.19
        for <linux-media@vger.kernel.org>; Sun, 27 May 2012 10:27:42 -0700 (PDT)
Message-ID: <4FC2640C.1070708@gmail.com>
Date: Sun, 27 May 2012 19:27:40 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] media: reorganize the main Kconfig items
References: <4FC24E34.3000406@redhat.com> <1338137803-12231-1-git-send-email-mchehab@redhat.com> <1338137803-12231-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1338137803-12231-2-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 05/27/2012 06:56 PM, Mauro Carvalho Chehab wrote:
> Change the main items to:
>
> <m>  Multimedia support  --->
>     [ ]   Webcams and video grabbers support
>     [ ]   Analog TV API and drivers support
>     [ ]   Digital TV support
>     [ ]   AM/FM radio receivers/transmitters support
>     [ ]   Remote Controller support
>
> This provides an interface that is clearer to end users that
> are compiling the Kernel, and will allow the building system
> to automatically unselect drivers for unused functions.

The change looks reasonable to me, however I have few doubts with
regards to the naming. Is V4L2 really only for webcams? :)

How about renaming:

MEDIA_WEBCAM -> MEDIA_CAMERA,
*_SUPP -> _SUPPORT (grep gives many more results for the full word),
Webcams -> Cameras ?


Regards,
Sylwester

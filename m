Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1LLGfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 01:35:16 -0500
Received: by wgbdr13 with SMTP id dr13so10758671wgb.1
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 22:35:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE359CF.7090707@redhat.com>
References: <CAHFNz9+J69YqY06QRSPV+1a0gT1QSmw7cqqnW5AEarF-V5xGCw@mail.gmail.com>
	<4EE359CF.7090707@redhat.com>
Date: Mon, 12 Dec 2011 12:05:15 +0530
Message-ID: <CAHFNz9JC=r_hzkU1HOGvVkqHS-YZ0b7hatowgSaxpS7g58OVdA@mail.gmail.com>
Subject: Re: v4 [PATCH 00/10] Query DVB frontend delivery capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 10, 2011 at 6:38 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> On 10-12-2011 02:41, Manu Abraham wrote:
>>
>> Hi,
>>
>>  As discussed prior, the following changes help to advertise a
>>  frontend's delivery system capabilities.
>>
>>  Sending out the patches as they are being worked out.
>>
>>  The following patch series are applied against media_tree.git
>>  after the following commit
>>
>>  commit e9eb0dadba932940f721f9d27544a7818b2fa1c5
>>  Author: Hans Verkuil<hans.verkuil@cisco.com>
>>  Date:   Tue Nov 8 11:02:34 2011 -0300
>>
>>     [media] V4L menu: add submenu for platform devices
>
>
>
> A separate issue: please, don't send patches like that as attachment. It
> makes
> hard for people review. Instead, you should use git send-email. There's even
> an example there (at least on git version 1.7.8) showing how to set it for
> Google:


I don't have net access configured for the box where I do
tests/on the testbox. The outgoing mail from my side is
through the gmail web interface. If I don't attach the
patches, gmail garbles those patches.

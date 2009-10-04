Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbZJDOJt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 10:09:49 -0400
Message-ID: <4AC8ADA7.6010609@redhat.com>
Date: Sun, 04 Oct 2009 16:13:59 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Tool to measure frame rate
References: <62e5edd40910040328oa0db0f3h9d388ea47ae6671@mail.gmail.com>
In-Reply-To: <62e5edd40910040328oa0db0f3h9d388ea47ae6671@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/04/2009 12:28 PM, Erik Andrén wrote:
> Hi list,
>
> Could someone recommend a program that measures the frame rate of a
> video capturing device (webcam)?
>

I usually use camorama for this, note camorama is buggy, you will want to
apply the patches from:
http://cvs.fedoraproject.org/viewvc/devel/camorama/

In this order:
camorama-0.19-fixes.patch
camorama-0.19-libv4l.patch

Note the fixes one is the only one you really need, the other one merely
makes camorama use libv4l, so you don't need to LD_PRELOAD it.

Regards,

Hans

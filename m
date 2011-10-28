Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53297 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1J1DG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Oct 2011 23:06:26 -0400
Received: by qyk27 with SMTP id 27so4023378qyk.19
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2011 20:06:26 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 28 Oct 2011 03:05:25 +0000
Message-ID: <CAE_m23nibPcf0-eQmpAfuevotCio-KdVN_o+d+74dPzfTQcs-Q@mail.gmail.com>
Subject: Increase max exposure value to 255 from 26 for pac207
From: =?ISO-8859-1?Q?Marco_Diego_Aur=E9lio_Mesquita?=
	<marcodiegomesquita@gmail.com>
To: linux-media <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devs!

There's a patch I sent some time ago[1] to increase the max exposure
value on pac207 based webcams. I see no problem with the patch, it has
survived hours of tests and is a simple on-liner.

It has been in queue for months now, and I really would like to get it
merged. Please, is there anything I can do about it?

[1] http://patchwork.linuxtv.org/patch/6850/

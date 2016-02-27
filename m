Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq6.tb.mail.iss.as9143.net ([212.54.42.169]:39623 "EHLO
	smtpq6.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756331AbcB0OZZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 09:25:25 -0500
Subject: Re: [PATCH] v4lconvert: Add "PEGATRON CORPORATION" to
 asus_board_vendor
To: Hans de Goede <hdegoede@redhat.com>,
	Gregor Jasny <gjasny@googlemail.com>
References: <1456580424-9627-1-git-send-email-hdegoede@redhat.com>
 <1456580424-9627-2-git-send-email-hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	istaff124@gmail.com
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Message-ID: <56D1A9B8.10305@grumpydevil.homelinux.org>
Date: Sat, 27 Feb 2016 14:50:48 +0100
MIME-Version: 1.0
In-Reply-To: <1456580424-9627-2-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On 27-02-16 14:40, Hans de Goede wrote:
> Some Asus laptops actually have "PEGATRON CORPORATION" in board_vendor,
> add this to the list of strings used to recognize Asus as vendor.
>
> This also allows us to remove a bunch of PEGATRON entries from the static
> v4lcontrol_flags table.
>
>

Do not know what the current ownership structure is, but pegatron used 
to be called Unihan, and is/was part of the Asus group

Cheers

Rudy

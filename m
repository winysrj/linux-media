Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63625 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118Ab1J3QVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 12:21:36 -0400
Received: by gyb13 with SMTP id 13so5100861gyb.19
        for <linux-media@vger.kernel.org>; Sun, 30 Oct 2011 09:21:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbzLrRGa8MvziFd_OLaJEUyzXgjK-w4vL95gykOwz5otHQ@mail.gmail.com>
References: <4EAB342F.2020008@lockie.ca>
	<201110290221.05015.marek.vasut@gmail.com>
	<4EAB612A.6010003@xenotime.net>
	<4EAB8B5A.5040908@lockie.ca>
	<4EAB919A.6020401@xenotime.net>
	<4EAB9F41.40208@redhat.com>
	<CAOcJUbzLrRGa8MvziFd_OLaJEUyzXgjK-w4vL95gykOwz5otHQ@mail.gmail.com>
Date: Sun, 30 Oct 2011 09:21:36 -0700
Message-ID: <CAA7C2qgJR-_-63oQK-vXMT54g=yvJiqKuuWryNZ9PBW16iUpdA@mail.gmail.com>
Subject: Re: femon patch for dB
From: VDR User <user.vdr@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	James <bjlockie@lockie.ca>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 30, 2011 at 6:52 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> I will push the work for the ATSC snr conversions to my git repository
> and issue a pull request to Mauro by the end of the day.  This issue
> is larger than a simple userspace unit conversion.  Please send in the
> patch inline anyway, as some users may wish to experiment with it, but
> we need to first standardize the kernel unit reporting before we claim
> to report in a given unit.

This topic comes up every so often but afaik nothing is ever done
beyond talking.  Are there actually plans to finally get this done?  I
hope so since it's useful information to the user rather than just
some value given in an unknown scale.

Sorry if my question is OT.

Derek

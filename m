Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f211.google.com ([209.85.218.211]:45085 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0CIUFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 15:05:24 -0500
Received: by bwz3 with SMTP id 3so1270455bwz.29
        for <linux-media@vger.kernel.org>; Tue, 09 Mar 2010 12:05:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a3ef07921003091155q2a11335bo887251ed2c3300d2@mail.gmail.com>
References: <4B969C08.2030807@redhat.com>
	 <a3ef07921003091155q2a11335bo887251ed2c3300d2@mail.gmail.com>
Date: Tue, 9 Mar 2010 15:05:22 -0500
Message-ID: <829197381003091205vfeb1e81oa09b8320f02cd2c5@mail.gmail.com>
Subject: Re: Status of the patches under review (45 patches)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: VDR User <user.vdr@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, moinejf@free.fr,
	m-karicheri2@ti.com, g.liakhovetski@gmx.de, pboettcher@dibcom.fr,
	tobias.lorenz@gmx.net, awalls@radix.net, khali@linux-fr.org,
	hdegoede@redhat.com, abraham.manu@gmail.com, hverkuil@xs4all.nl,
	crope@iki.fi, davidtlwong@gmail.com, henrik@kurelid.se,
	stoth@kernellabs.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 9, 2010 at 2:55 PM, VDR User <user.vdr@gmail.com> wrote:
> What happened to the statistics patch?

The statistics patch still needs a ton of work before it could be
accepted upstream.  Mostly these things are related to clarification
as to how the API should behave and how a variety of edge cases should
be handled.  I came up with about three paragraphs worth of issues
with the proposed approach, but haven't had a chance to push it to the
mailing list for further discussion.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

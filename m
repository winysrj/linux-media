Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:36059 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaDYSyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Apr 2014 14:54:41 -0400
Received: by mail-qc0-f179.google.com with SMTP id l6so3655300qcy.10
        for <linux-media@vger.kernel.org>; Fri, 25 Apr 2014 11:54:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOS+5GGC8-Pbx9eoA0eNYU0sH5bEzqUKsuowog2BQ214djUmjA@mail.gmail.com>
References: <CAOS+5GGaHQvO30fhgG6PYGc2POHFiFwHvDozZ6k6f_1MEy9_eA@mail.gmail.com>
	<CAGoCfiyuG0q-pCsPsSkMPFa8V+qo97ewY7ngyu4Mhmu_45RDYw@mail.gmail.com>
	<CAOS+5GGC8-Pbx9eoA0eNYU0sH5bEzqUKsuowog2BQ214djUmjA@mail.gmail.com>
Date: Fri, 25 Apr 2014 14:54:40 -0400
Message-ID: <CAGoCfixkrKSAcY_mmW51OQX7es4tL3_dyWMtbQ6a5oVXjE-5mQ@mail.gmail.com>
Subject: Re: Elgato Eye TV Deluxe V2 supported?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Another Sillyname <anothersname@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Is the as102 tree ever likely to go mainline?

The only reason it's in staging is because it doesn't meet the coding
standards (i.e. whitespace, variable naming, etc).  Somebody needs to
come along and expend the energy to satisfy the whitespace gods.

Seems like a fantastically stupid reason to keep a working driver out
of the mainline, but that's just my opinion.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

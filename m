Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43414 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2GaT4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 15:56:13 -0400
Received: by gglu4 with SMTP id u4so6500234ggl.19
        for <linux-media@vger.kernel.org>; Tue, 31 Jul 2012 12:56:13 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 31 Jul 2012 15:56:12 -0400
Message-ID: <CAGoCfizvvq7C+axexewU_wrmhhggoiNJ7D5H3=SPfa3jaxpVcA@mail.gmail.com>
Subject: Reporting signal overload condition for tuners?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

Quick question:  we don't currently have any way to report to userland
that a tuning is failing due to signal overload, right?

There are some tuner chips out there which can detect this condition,
and being able to report it back to userland would make it much easier
to inform the user that he/she needs to stick an attenuator inline.

Has anybody given any thought to this before?  Perhaps use up the last
available bit in fe_status for DVB?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

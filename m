Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34943 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1ANPMU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 10:12:20 -0500
Received: by ewy5 with SMTP id 5so1476635ewy.19
        for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 07:12:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BA2A2355403563449C28518F517A3C4805AA9B9B@titan.logiways-france.fr>
References: <BA2A2355403563449C28518F517A3C4805AA9B9B@titan.logiways-france.fr>
Date: Fri, 14 Jan 2011 10:12:19 -0500
Message-ID: <AANLkTi=Y_ikxp2hHHh5B=rQqQLf5w5_5SivzLJ+DfVLm@mail.gmail.com>
Subject: Re: [linux-media] API V3 vs SAPI behavior difference in reading
 tuning parameters
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Thierry LELEGARD <tlelegard@logiways.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 14, 2011 at 8:35 AM, Thierry LELEGARD
<tlelegard@logiways.com> wrote:
> But there is worse. If I set a wrong parameter in the tuning operation,
> for instance guard interval 1/32, the API V3 returns the correct value
> which is actually used by the tuner (GUARD_INTERVAL_1_8), while S2API
> returns the "cached" value which was set while tuning (GUARD_INTERVAL_1_32).

This is actually a bad thing.  If you specify the wrong parameter and
it still works, then that can lead to all sort of misleading behavior.
 For example, imagine the next person who submits scan results based
on using such a driver.  It works for him because his driver lied, but
the resulting file works for nobody else.

If you specify an explicit value incorrectly (not auto) and it still
works, that is a driver bug which should be fixed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

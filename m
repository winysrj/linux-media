Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.southpole.se ([37.247.8.11]:59002 "EHLO mail.southpole.se"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbcLAK40 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Dec 2016 05:56:26 -0500
Subject: Re: [PATCH 1/2] mn88473: fix chip id check on probe
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
References: <1480552186-1179-1-git-send-email-crope@iki.fi>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <54bfb922-d080-b4aa-2a72-058110cd294c@southpole.se>
Date: Thu, 1 Dec 2016 11:56:22 +0100
MIME-Version: 1.0
In-Reply-To: <1480552186-1179-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-12-01 01:29, Antti Palosaari wrote:
> A register used to identify chip during probe was overwritten during
> firmware download and due to that later probe's for warm chip were
> failing. Detect chip from the another register, which is located on
> different register bank 2.
>
> Fixes: 7908fad99a6c ("[media] mn88473: finalize driver")
> Cc: <stable@vger.kernel.org> # v4.8+
> Signed-off-by: Antti Palosaari <crope@iki.fi>

I can confirm that I saw something with regards to this one time before.

MvH
Benjamin Larsson

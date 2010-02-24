Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab0BXNKx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 08:10:53 -0500
Message-ID: <4B852538.2050207@redhat.com>
Date: Wed, 24 Feb 2010 10:10:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>,
	Douglas Landgraf <dougsland@gmail.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: Status of the patches under review (29 patches)
References: <4B84BBB0.1020408@redhat.com> <20100224101807.60a468c3@hyperion.delvare>
In-Reply-To: <20100224101807.60a468c3@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Jean Delvare wrote:
 
> I have 3 patches pending which aren't in your list. I can see them in
> patchwork:
> 
> http://patchwork.kernel.org/patch/79755/
> http://patchwork.kernel.org/patch/79754/
> http://patchwork.kernel.org/patch/77349/
> 
> The former two are in "Accepted" state, and actually I received an
> e-mail telling me they had been accepted, however I can't see them in
> the hg repository. So where are they?

They are already on the git tree:

commit 2887117b31b77ebe5fb42f95ea8d77a3716b405b
Author: Jean Delvare <khali@linux-fr.org>
Date:   Tue Feb 16 14:22:37 2010 -0300

    V4L/DVB: bttv: Let the user disable IR support
    
    Add a new module parameter "disable_ir" to disable IR support. Several
    other drivers do that already, and this can be very handy for
    debugging purposes.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

commit e151340a2a9e7147eb48114af0381122130266b0
Author: Jean Delvare <khali@linux-fr.org>
Date:   Fri Feb 19 00:18:41 2010 -0300

    V4L/DVB: bttv: Move I2C IR initialization
    
    Move I2C IR initialization from just after I2C bus setup to right
    before non-I2C IR initialization. This avoids the case where an I2C IR
    device is blocking audio support (at least the PV951 suffers from
    this). It is also more logical to group IR support together,
    regardless of the connectivity.
    
    This fixes bug #15184:
    http://bugzilla.kernel.org/show_bug.cgi?id=15184
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    CC: stable@kernel.org
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

As patches in -hg are manually backported, maybe Douglas
haven't backported it yet or he simply missed.

Douglas, could you please check this?

> The latter is in "Not Applicable" state, and I have no idea what it
> means. The patch is really simple and I see no formatting issue. Should
> I just resend it?

This means that this patch is not applicable on -git. There's no versions.txt
upstream. All patches that don't have upstream code are marked as such on
patchwork. I generally ping Douglas on such cases, for him to double check on
-hg.

Anyway, the better is to c/c to Douglas on all patches that are meant only
to the building system.

Douglas, could you please check if you've applied this patch?

-- 

Cheers,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:34424 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932454AbdLGNXJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 08:23:09 -0500
Received: by mail-wr0-f176.google.com with SMTP id y21so7481116wrc.1
        for <linux-media@vger.kernel.org>; Thu, 07 Dec 2017 05:23:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d39690b8-ca6d-c7b4-3ddc-ba049d830b0f@cisco.com>
References: <cover.1512582979.git.joabreu@synopsys.com> <fd906727f9f507bcc748125972cae447cf1e5644.1512582979.git.joabreu@synopsys.com>
 <d39690b8-ca6d-c7b4-3ddc-ba049d830b0f@cisco.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Thu, 7 Dec 2017 14:22:27 +0100
Message-ID: <CAOFm3uEkPKzVWUhk7JP_inusZjCVgqtxDguRxVgB-DHh1J1o9g@mail.gmail.com>
Subject: Re: [PATCH v9 4/4] [media] platform: Add Synopsys DesignWare HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jose,

On Thu, Dec 7, 2017 at 1:33 PM, Hans Verkuil <hansverk@cisco.com> wrote:
> Hi Jose,
>
> Some (small) comments below:
>
> On 12/07/17 10:47, Jose Abreu wrote:
>> This is an initial submission for the Synopsys DesignWare HDMI RX
>> Controller Driver. This driver interacts with a phy driver so that
>> a communication between them is created and a video pipeline is
>> configured.
>>
>> The controller + phy pipeline can then be integrated into a fully
>> featured system that can be able to receive video up to 4k@60Hz
>> with deep color 48bit RGB, depending on the platform. Although,
>> this initial version does not yet handle deep color modes.
>>
>> This driver was implemented as a standard V4L2 subdevice and its
>> main features are:
>>       - Internal state machine that reconfigures phy until the
>>       video is not stable
>>       - JTAG communication with phy
>>       - Inter-module communication with phy driver
>>       - Debug write/read ioctls
>>
>> Some notes:
>>       - RX sense controller (cable connection/disconnection) must
>>       be handled by the platform wrapper as this is not integrated
>>       into the controller RTL
>>       - The same goes for EDID ROM's
>>       - ZCAL calibration is needed only in FPGA platforms, in ASIC
>>       this is not needed
>>       - The state machine is not an ideal solution as it creates a
>>       kthread but it is needed because some sources might not be
>>       very stable at sending the video (i.e. we must react
>>       accordingly).
>>
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> Cc: Joao Pinto <jpinto@synopsys.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
[]
>> --- /dev/null
>> +++ b/drivers/media/platform/dwc/dw-hdmi-rx.h
>> @@ -0,0 +1,441 @@
>> +/*
>> + * Synopsys Designware HDMI Receiver controller driver
>> + *
>> + * This Synopsys dw-hdmi-rx software and associated documentation
>> + * (hereinafter the "Software") is an unsupported proprietary work of
>> + * Synopsys, Inc. unless otherwise expressly agreed to in writing betwe=
en
>> + * Synopsys and you. The Software IS NOT an item of Licensed Software o=
r a
>> + * Licensed Product under any End User Software License Agreement or
>> + * Agreement for Licensed Products with Synopsys or any supplement ther=
eto.
>> + * Synopsys is a registered trademark of Synopsys, Inc. Other names inc=
luded
>> + * in the SOFTWARE may be the trademarks of their respective owners.
>> + *
>> + * The contents of this file are dual-licensed; you may select either v=
ersion 2
>> + * of the GNU General Public License (=E2=80=9CGPL=E2=80=9D) or the MIT=
 license (=E2=80=9CMIT=E2=80=9D).
>> + *
>> + * Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
>> + *
>> + * THIS SOFTWARE IS PROVIDED "AS IS"  WITHOUT WARRANTY OF ANY KIND, EXP=
RESS OR
>> + * IMPLIED, INCLUDING, BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABI=
LITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT S=
HALL THE
>> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWIS=
E
>> + * ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */


My heart bleeds when I see such a long legalese crap obstructing your
otherwise fine code contributions.

Would you be kind enough to consider using the new SPDX ids as
documented by Thomas and commented and agreed by Linus, Greg and other
maintainers?
This has the same effect, but is much more concise and readable.

This could come out this way in this example:

>> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
>> +/*
>> + * Synopsys Designware HDMI Receiver controller driver
>> + *
>> + * Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
>> + *
>> + */

Or even better using C++ /// style comments if this works for your
code. These are preferred by Linus for such things (and requested for
.c files SPDX ids vs. .h includes):

>> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
>> +// Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
>> +// Synopsys Designware HDMI Receiver controller driver

Think of it this way: unless you are a legalese lover or a
lawyer-who-codes and confused the kernel with a licensing contract
draft, you now have improved the signal/noise ratio of your code quite
nicely by removing about 20 lines of comments.

And if someone ever prints your code, you will have saved a tree or
two and be a good earth citizen.
And even better, you can now grep your code for licenses, unambiguously.

If you could do this that would be really nice: we already have tagged
~13K files with SPDX and they are now in Linus's tree. We still have
roughly 60K files to do... so every little help that would avoid
piling up more work for us with new and innovative legalese
boilerplate would really be much appreciated.

Extra bonus: you can also do this for all your past, present and
future contributions.... and spread the good word at your company so
that everyone does the same: with this small thing you will earn at
least 10 or more extra good karma points and my eternal gratitude.

Thank you for your kind consideration, your friendly kernel licensing janit=
or!
--=20
Cordially
Philippe Ombredanne

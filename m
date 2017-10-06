Return-path: <linux-media-owner@vger.kernel.org>
Received: from unicorn.mansr.com ([81.2.72.234]:44836 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751511AbdJFKrD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 06:47:03 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Sean Young <sean@mess.org>
Cc: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>,
        linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
Subject: Re: [PATCH v7 3/3] media: rc: Add tango keymap
References: <a98feda2-fd9e-004b-a139-789193ca4995@sigmadesigns.com>
        <13b59e8a-d276-d19a-7f07-70a2423526ab@sigmadesigns.com>
        <20171005215246.q7m4ewyfytnbs46a@gofer.mess.org>
Date: Fri, 06 Oct 2017 11:47:01 +0100
In-Reply-To: <20171005215246.q7m4ewyfytnbs46a@gofer.mess.org> (Sean Young's
        message of "Thu, 5 Oct 2017 22:52:46 +0100")
Message-ID: <yw1xmv54pn8a.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sean Young <sean@mess.org> writes:

> Hi Marc,
>
> Looks great, just some minor nitpicks.
>
> On Thu, Oct 05, 2017 at 04:54:11PM +0200, Marc Gonzalez wrote:
>> Add a keymap for the Sigma Designs Vantage (dev board) remote control.
>> 
>> Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
>> ---
>>  drivers/media/rc/keymaps/Makefile   |  1 +
>>  drivers/media/rc/keymaps/rc-tango.c | 84 +++++++++++++++++++++++++++++++++++++
>>  drivers/media/rc/tango-ir.c         |  2 +-
>>  include/media/rc-map.h              |  1 +
>>  4 files changed, 87 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/media/rc/keymaps/rc-tango.c
>> 
>> diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
>> index af6496d709fb..3c1e31321e21 100644
>> --- a/drivers/media/rc/keymaps/Makefile
>> +++ b/drivers/media/rc/keymaps/Makefile
>> @@ -88,6 +88,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
>>  			rc-reddo.o \
>>  			rc-snapstream-firefly.o \
>>  			rc-streamzap.o \
>> +			rc-tango.o \
>>  			rc-tbs-nec.o \
>>  			rc-technisat-ts35.o \
>>  			rc-technisat-usb2.o \
>> diff --git a/drivers/media/rc/keymaps/rc-tango.c b/drivers/media/rc/keymaps/rc-tango.c
>> new file mode 100644
>> index 000000000000..c76651695959
>> --- /dev/null
>> +++ b/drivers/media/rc/keymaps/rc-tango.c
>> @@ -0,0 +1,84 @@
>
> I think you need a header with copyright statement and GPL version(s).

Is this even copyrightable?

-- 
Måns Rullgård

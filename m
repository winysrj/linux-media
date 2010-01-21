Return-path: <linux-media-owner@vger.kernel.org>
Received: from emearegistrations.com ([209.190.30.226]:40572 "EHLO
	mx.emearegistrations.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab0AUM0H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 07:26:07 -0500
Message-ID: <4B5847BD.5030507@0bits.com>
Date: Thu, 21 Jan 2010 16:25:33 +0400
From: dm66@0bits.com
MIME-Version: 1.0
To: Samuel Rakitnican <samuel.rakitnican@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: TT-Budget/S-1500 PCI crashes with current hg (v4l-dvb-cdcf089168df)
References: <4B580684.8070004@0bits.com> <op.u6vsu3eq6dn9rq@denis-laptop.lan>
In-Reply-To: <op.u6vsu3eq6dn9rq@denis-laptop.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/21/10 15:58, Samuel Rakitnican wrote:
> Hi,
>
> for the kernel crash, there was a breakage introduced recently so all
> devices with an IR cause a kernel oops without the following patch:
> http://patchwork.kernel.org/patch/70126/
>
> Regards
>
> On Thu, 21 Jan 2010 08:47:16 +0100, <dm66@0bits.com> wrote:
>
>> Hi,
>>
>> My Technotrend S-1500 crashes everytime i load the drivers. This is on
>> 2.6.30.10 kernel with a 2 day old tip from mercurial repo on linuxtv.
>>
>> Reverting back to an older build seems to succeed but i have other
>> tuning problems. Looks like a prob in the infrared driver
>> registration. Is there any way to disable the IR totally as this is a
>> backend server in a mythtv config. Here's the panic/crash:


I did google before i posted and the patch aforementioned *is* in the 
current mercurial source  (v4l-dvb-cdcf089168df):

home:/usr/src/mythtv/v4l-dvb-cdcf089168df$ sed -n 121,132p 
linux/drivers/media/IR/ir-sysfs.c


/*
  * Static device attribute struct with the sysfs attributes for IR's
  */
static DEVICE_ATTR(current_protocol, S_IRUGO | S_IWUSR,
		   show_protocol, store_protocol);

static struct attribute *ir_dev_attrs[] = {
	&dev_attr_current_protocol.attr,
	NULL,
};

home:/usr/src/mythtv/v4l-dvb-cdcf089168df$


Any other ideas ?

D

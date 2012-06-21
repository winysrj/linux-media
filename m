Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53515 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760104Ab2FUWnw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 18:43:52 -0400
Received: by pbbrp8 with SMTP id rp8so2724430pbb.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 15:43:52 -0700 (PDT)
Message-ID: <4FE3A3A6.5050500@gmail.com>
Date: Thu, 21 Jun 2012 15:43:50 -0700
From: Mack Stanley <mcs1937@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Chipset change for CX88_BOARD_PINNACLE_PCTV_HD_800i
References: <4FE24132.4090705@gmail.com> <CAGoCfixL-tEFq4SpjxChH7uc0aDZGtdoO6EqrEH3tzPzoTqK8w@mail.gmail.com>
In-Reply-To: <CAGoCfixL-tEFq4SpjxChH7uc0aDZGtdoO6EqrEH3tzPzoTqK8w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2012 03:14 PM, Devin Heitmueller wrote:
> On Wed, Jun 20, 2012 at 5:31 PM, Mack Stanley <mcs1937@gmail.com> wrote:
>> Dear Mr. Pascoe,
>>
>> I'm writing to you as the maintainer of the cx88-dvb kernel module.
>>
>> I recently bought a pci tv card that the kernel identifies as supported:
>>
>> 05:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
>> CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
>> Subsystem: Pinnacle Systems Inc. Device [11bd:0051]
>>
>> My card appears to be the same card as this Pinnacle card
>> (http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_%28800i%29)
>> except that it has a Samsung S5H1411 chip in place of the S5H1409 on the
>> original Pinnacle card identified by the kernel.
>>
>> My card is branded "PCTV HD PCI Card 800i"
>> (http://www.pctvsystems.com/Products/ProductsNorthAmerica/HybridproductsUSA/PCTVHDCard/tabid/171/language/en-US/Default.aspx),
>> though I bought it as a Hauppauge card
>> (http://www.newegg.com/Product/Product.aspx?Item=15-116-043&SortField=0&SummaryType=0&Pagesize=10&PurchaseMark=&SelectedRating=-1&VideoOnlyMark=False&VendorMark=&IsFeedbackTab=true&Keywords=linux&Page=1#scrollFullInfo).
>>
>> Because of the changed chip, "dvb_attach" returns NULL, so the cx88-dvb
>> module fails to insert, and no /dev/dvb nodes are created.
>>
>> I was able to get around this by copying s5h1411_config
>> dvico_fusionhdtv7_config to a new
>> "s5h1411_config pinnacle_pctv_hd_800i_config", then replacing
>> s5h1409_attach with s5h1411_attach in
>> case CX88_BOARD_PINNACLE_PCTV_HD_800i in the definition of dvb_register.
>>
>> I built against headers for Fedora 16 kernel 3.3.8-1.fc16.x86_64.  The
>> result loads normally and creates /dev/dvb/adaper0 containing demux0,
>> dvr0,  frontend0,  and net0.
>>
>> "w_scan -fa -A2 -c US -x " produces a long list of frequencies, all but
>> two of which are in us-Cable-IRC-center-frequencies-QAM256. However,
>> w_scan finds no "services" and I haven't been able to coax either
>> scandvb or scte65scan into finding any channels. I don't know whether
>> this is because my shot-in-the-dark modification to cx88-dvb doesn't
>> work, or because Comcast has some screwy way of sending signals to its
>> DTA's.
>>
>> I'm of course more than happy to help in any way.
>>
>> Thanks for your time,
>> Mack
> Hmmm, ok.  Let me talk to my contacts at PCTV and see what the deal is
> there.  My guess is the 1409 reached end of life, so they had to
> switch to the 1411.
>
> I'm pretty surprised that they didn't bump the PCI ID though.  I'll
> find out if they're relying on the eeprom to know which demod is
> present.
>
> The scan is probably failing due to something like a mismatched IF
> output frequency.
>
> Devin
>
Hi Devin,

Thanks very much for your help.

In fact, it seems I have the card working, following your suggestion
about the channel scan failing. But I suspect something is still missing
or worng.

I've been able to successfully scan for channels with scandvb and get a
usable channel.conf using scte65scan. But selecting channels is erratic.

mplayer [various options] dvb://6

tunes to different channels different times, sometimes to video from one
channel and sound from another, sometimes to video but no sound.

I just took some setting from the old 1409 configuration and used them
for the 1411 chip:

static const struct s5h1411_config pinnacle_pctv_hd_800i_config = {
  .output_mode   = S5H1411_PARALLEL_OUTPUT,
  .gpio          = S5H1411_GPIO_ON,
  .mpeg_timing   = S5H1411_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK,
  .qam_if        = S5H1411_IF_44000,
  .vsb_if        = S5H1411_IF_44000,
  .inversion     = S5H1411_INVERSION_OFF,
  .status_mode   = S5H1411_DEMODLOCKING
};

I'll be interested in what your contacts at pctv suggest.

Best, Mack

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:62292 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZJWAMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 20:12:07 -0400
Received: by ewy4 with SMTP id 4so1169952ewy.37
        for <linux-media@vger.kernel.org>; Thu, 22 Oct 2009 17:12:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1a297b360910221329o4b832f4ewaee08872120bfea0@mail.gmail.com>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	 <20091023051025.597c05f4@caramujo.chehab.org>
	 <1a297b360910221329o4b832f4ewaee08872120bfea0@mail.gmail.com>
Date: Fri, 23 Oct 2009 02:12:11 +0200
Message-ID: <d9def9db0910221712h39ee4591xb3f3bdbeb4113de8@mail.gmail.com>
Subject: Re: Details about DVB frontend API
From: Markus Rechberger <mrechberger@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 22, 2009 at 10:29 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> On Fri, Oct 23, 2009 at 12:10 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> Em Thu, 22 Oct 2009 21:13:30 +0200
>> Jean Delvare <khali@linux-fr.org> escreveu:
>>
>>> Hi folks,
>>>
>>> I am looking for details regarding the DVB frontend API. I've read
>>> linux-dvb-api-1.0.0.pdf, it roughly explains what the FE_READ_BER,
>>> FE_READ_SNR, FE_READ_SIGNAL_STRENGTH and FE_READ_UNCORRECTED_BLOCKS
>>> commands return, however it does not give any information about how the
>>> returned values should be interpreted (or, seen from the other end, how
>>> the frontend kernel drivers should encode these values.) If there
>>> documentation available that would explain this?
>>>
>>> For example, the signal strength. All I know so far is that this is a
>>> 16-bit value. But then what? Do greater values represent stronger
>>> signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
>>> returned value meaningful even when FE_HAS_SIGNAL is 0? When
>>> FE_HAS_LOCK is 0? Is the scale linear, or do some values have
>>> well-defined meanings, or is it arbitrary and each driver can have its
>>> own scale? What are the typical use cases by user-space application for
>>> this value?
>>>
>>> That's the kind of details I'd like to know, not only for the signal
>>> strength, but also for the SNR, BER and UB. Without this information,
>>> it seems a little difficult to have consistent frontend drivers.
>>
>> We all want to know about that ;)
>>
>> Seriously, the lack of a description of the meaning of the ranges for those
>> read values were already widely discussed at LMML and at the legacy dvb ML.
>> We should return this discussion again and decide what would be the better
>> way to describe those values.
>>
>> My suggestion is that someone summarize the proposals we had and give some time
>> for people vote. After that, we just commit the most voted one, and commit the
>> patches for it. A pending question that should also be discussed is what we will
>> do with those dvb devices where we simply don't know what scale it uses. There
>> are several of them.
>
>
> Sometime back, (some time in April) i proposed a patch which addressed
> the issue to scale "even those devices which have a weird scale or
> none". Though based on an older tree of mine, here is the patch again.
> If it looks good enough, i can port the patch to accomodate other
> devices as well.
>

A few of our customers were requiring additional statistic
information, so we added follwing
command to our DVB API:

FE_GET_SIGQUALITY

struct media_sigquality {
   uint16_t MER;                  /**< in steps of 0.1 dB
          */
   uint32_t preViterbiBER ;       /**< in steps of 1/scaleFactorBER
          */
   uint32_t postViterbiBER ;      /**< in steps of 1/scaleFactorBER
          */
   uint32_t scaleFactorBER;       /**< scale factor for BER
          */
   uint32_t packetError ;         /**< number of packet errors
          */
   uint32_t postReedSolomonBER ;  /**< in steps of 1/scaleFactorBER
          */
   uint32_t indicator;            /**< indicative signal quality
low=0..100=high */
}

It's a one shot request.
it might be good to standardize this, although we can live with that
additional command too.

Best Regards,
Markus

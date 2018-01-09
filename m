Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48010 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755454AbeAIFSe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 00:18:34 -0500
Subject: Re: [PATCH 7/9] lgdt3306a: Set fe ops.release to NULL if probed
To: Michael Ira Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>
Cc: linux-media <linux-media@vger.kernel.org>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
 <1515110659-20145-8-git-send-email-brad@nextdimension.cc>
 <CAOcJUbxdODb2_txnrKgEa23-tq4AQzV4eGiDQuvXYNpofcvzAw@mail.gmail.com>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <485ca421-1a94-29cb-66ea-6bdea1ac5fe8@gentoo.org>
Date: Tue, 9 Jan 2018 06:17:49 +0100
MIME-Version: 1.0
In-Reply-To: <CAOcJUbxdODb2_txnrKgEa23-tq4AQzV4eGiDQuvXYNpofcvzAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.01.2018 um 01:19 schrieb Michael Ira Krufky:
> On Thu, Jan 4, 2018 at 7:04 PM, Brad Love <brad@nextdimension.cc> wrote:
>> If release is part of frontend ops then it is called in the
>> course of dvb_frontend_detach. The process also decrements
>> the module usage count. The problem is if the lgdt3306a
>> driver is reached via i2c_new_device, then when it is
>> eventually destroyed remove is called, which further
>> decrements the module usage count to negative. After this
>> occurs the driver is in a bad state and no longer works.
>> Also fixed by NULLing out the release callback is a double
>> kfree of state, which introduces arbitrary oopses/GPF.
>> This problem is only currently reachable via the em28xx driver.
>>
>> On disconnect of Hauppauge SoloHD before:
>>
>> lsmod | grep lgdt3306a
>> lgdt3306a              28672  -1
>> i2c_mux                16384  1 lgdt3306a
>>
>> On disconnect of Hauppauge SoloHD after:
>>
>> lsmod | grep lgdt3306a
>> lgdt3306a              28672  0
>> i2c_mux                16384  1 lgdt3306a
>>
>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>> ---
>>  drivers/media/dvb-frontends/lgdt3306a.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
> 
> Brad,
> 
> We won't be able to apply this one.  The symptom that you're trying to
> fix is indicative of some other problem, probably in the em28xx
> driver.  NULL'ing the release callback is not the right thing to do.
> 

Hi Mike,
Why do you nak this perfectly fine patch?
Let me start to explain.

dvb_attach style drivers have an attach function and for unloading a
.release callback.

i2c-style drivers have a probe and a remove function.

Mixed style drivers must be constructed, that either release or remove
is called, never both.
They both do the same thing, but with different signature.


Now checking lgdt3306a driver:

dvb attach style:
In lgdt3306a_attach the release callback is set to lgdt3306a_release and
no remove exists. Fine.

i2c style probe:
struct i2c_driver contains lgdt3306a_probe and lgdt3306a_remove.
lgdt3306a_probe shares code and calls lgdt3306a_attach, but afterwards
the release callback field must be set to NULL.

This is/was done exactly like this in multiple other drivers as long as
they have been multiple style attachable.

Regards
Matthias

> 
>> diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
>> index 6356815..d2477ed 100644
>> --- a/drivers/media/dvb-frontends/lgdt3306a.c
>> +++ b/drivers/media/dvb-frontends/lgdt3306a.c
>> @@ -2177,6 +2177,7 @@ static int lgdt3306a_probe(struct i2c_client *client,
>>
>>         i2c_set_clientdata(client, fe->demodulator_priv);
>>         state = fe->demodulator_priv;
>> +       state->frontend.ops.release = NULL;
>>
>>         /* create mux i2c adapter for tuner */
>>         state->muxc = i2c_mux_alloc(client->adapter, &client->dev,
>> --
>> 2.7.4
>>
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:41218 "EHLO
        homiemail-a121.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751100AbeAEBhS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 20:37:18 -0500
Subject: Re: [PATCH 7/9] lgdt3306a: Set fe ops.release to NULL if probed
To: Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
 <1515110659-20145-8-git-send-email-brad@nextdimension.cc>
 <CAOcJUbxdODb2_txnrKgEa23-tq4AQzV4eGiDQuvXYNpofcvzAw@mail.gmail.com>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <1c01e895-534c-0a97-4463-dd6f0179e0f6@nextdimension.cc>
Date: Thu, 4 Jan 2018 19:37:17 -0600
MIME-Version: 1.0
In-Reply-To: <CAOcJUbxdODb2_txnrKgEa23-tq4AQzV4eGiDQuvXYNpofcvzAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2018-01-04 18:19, Michael Ira Krufky wrote:
> On Thu, Jan 4, 2018 at 7:04 PM, Brad Love <brad@nextdimension.cc> wrote=
:
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
> Brad,
>
> We won't be able to apply this one.  The symptom that you're trying to
> fix is indicative of some other problem, probably in the em28xx
> driver.  NULL'ing the release callback is not the right thing to do.
>
> -Mike Krufky

Hey Mike,

Redacting this patch to deal with individually. I will separately send
to the list an example of another bridge driver which exhibits the same
issue, when using the lgdt3306a driver similarly. I don't think this is
solely an em28xx issue. I will also send a patch fixing only the double
free, as that seems to be most important.

Cheers,

Brad





>> diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/d=
vb-frontends/lgdt3306a.c
>> index 6356815..d2477ed 100644
>> --- a/drivers/media/dvb-frontends/lgdt3306a.c
>> +++ b/drivers/media/dvb-frontends/lgdt3306a.c
>> @@ -2177,6 +2177,7 @@ static int lgdt3306a_probe(struct i2c_client *cl=
ient,
>>
>>         i2c_set_clientdata(client, fe->demodulator_priv);
>>         state =3D fe->demodulator_priv;
>> +       state->frontend.ops.release =3D NULL;
>>
>>         /* create mux i2c adapter for tuner */
>>         state->muxc =3D i2c_mux_alloc(client->adapter, &client->dev,
>> --
>> 2.7.4
>>

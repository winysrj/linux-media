Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:37694 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753701AbeAHUnw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 15:43:52 -0500
Received: from homiemail-a126.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id 1485A8DB5B
        for <linux-media@vger.kernel.org>; Mon,  8 Jan 2018 12:43:52 -0800 (PST)
Subject: Re: [PATCH 2/2] lgdt3306a: Fix a double kfree on i2c device remove
To: Matthias Schwarzott <zzam@gentoo.org>,
        Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1515164233-2423-1-git-send-email-brad@nextdimension.cc>
 <1515164233-2423-3-git-send-email-brad@nextdimension.cc>
 <86509eed-b1c3-f7d4-9281-47e072fb7232@gentoo.org>
From: Brad Love <brad@b-rad.cc>
Message-ID: <8c5dfc5c-db5b-8efe-2e1a-30b301b54c46@b-rad.cc>
Date: Mon, 8 Jan 2018 14:43:50 -0600
MIME-Version: 1.0
In-Reply-To: <86509eed-b1c3-f7d4-9281-47e072fb7232@gentoo.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2018-01-08 14:34, Matthias Schwarzott wrote:
> Am 05.01.2018 um 15:57 schrieb Brad Love:
>> Both lgdt33606a_release and lgdt3306a_remove kfree state, but _release=
 is
>> called first, then _remove operates on states members before kfree'ing=
 it.
>> This can lead to random oops/GPF/etc on USB disconnect.
>>
> lgdt3306a_release does nothing but the kfree. So the exact same effect
> can be archived by setting state->frontend.ops.release to NULL. This
> need to be done already at probe time I think.
> lgdt3306a_remove does this, but too late (after the call to release).
>
> Regards
> Matthias

Hi Matthias,

I agree. This was my rationale in the previous patch:

/patch/46328

Both methods handle the issue. I thought the previous
attempt was fairly clean, but it did not pass review, so
I provided this solution.

Cheers,

Brad







>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>> ---
>>  drivers/media/dvb-frontends/lgdt3306a.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/d=
vb-frontends/lgdt3306a.c
>> index d370671..3642e6e 100644
>> --- a/drivers/media/dvb-frontends/lgdt3306a.c
>> +++ b/drivers/media/dvb-frontends/lgdt3306a.c
>> @@ -1768,7 +1768,13 @@ static void lgdt3306a_release(struct dvb_fronte=
nd *fe)
>>  	struct lgdt3306a_state *state =3D fe->demodulator_priv;
>> =20
>>  	dbg_info("\n");
>> -	kfree(state);
>> +
>> +	/*
>> +	 * If state->muxc is not NULL, then we are an i2c device
>> +	 * and lgdt3306a_remove will clean up state
>> +	 */
>> +	if (!state->muxc)
>> +		kfree(state);
>>  }
>> =20
>>  static const struct dvb_frontend_ops lgdt3306a_ops;
>>

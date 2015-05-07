Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33000 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbbEGXgM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 19:36:12 -0400
Received: by igbpi8 with SMTP id pi8so20816270igb.0
        for <linux-media@vger.kernel.org>; Thu, 07 May 2015 16:36:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <554BCFE8.6020200@iki.fi>
References: <1430658023-17579-1-git-send-email-olli.salonen@iki.fi>
	<1430658023-17579-3-git-send-email-olli.salonen@iki.fi>
	<554BCFE8.6020200@iki.fi>
Date: Fri, 8 May 2015 01:36:11 +0200
Message-ID: <CAAZRmGxvwHnmRFeVC2H4mrotOr1EKco6UE9tmMBz3WbVFbN_KQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] si2168: add I2C error handling
From: Olli Salonen <olli.salonen@iki.fi>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

I basically used the same code that was used earlier in the same
function in case i2c_master_send/recv returns an unexpected result.

When working with the RTL2832P based Si2168 device I noticed that at
some point, often but not always during firmware loading, the Si2168
started to return error. When that happened any subsequent firmware
commands would fail as well. So it made sense to interrupt the loading
of firmware at the point when the first error is returned by the
demod. The reason for these I2C problems is not known - two hacks (rc
query interval increase and usage of the new I2C write method) were
used to mitigate the issue.

Based on the descriptions in
https://www.kernel.org/doc/Documentation/i2c/fault-codes EIO could be
applicable, though very loosely specified (which isn't necessary
wrong, as I don't have exact knowledge on which cases the error bit is
set):

EIO
    This rather vague error means something went wrong when
    performing an I/O operation.  Use a more specific fault
    code when you can.

The description for EINVAL doesn't match when it comes to the "before
any I/O operation was started", but other than that it might be
usable:

EINVAL
    This rather vague error means an invalid parameter has been
    detected before any I/O operation was started.  Use a more
    specific fault code when you can.

Looking at other DVB drivers, it seems it's mainly EREMOTEIO or EINVAL
that's used, depending on the case.

Cheers,
-olli

On 7 May 2015 at 22:49, Antti Palosaari <crope@iki.fi> wrote:
> Moikka!
> I didn't make any tests, but I could guess that error flag is set by
> firmware when some unsupported / invalid parameter is given as a firmware
> command request.
>
> Anyhow, I am not sure which is proper error code to return. Could you please
> study, check from API docs and so, which are suitable error codes. EINVAL
> sounds proper code, but imho it is not good as generally it is returned by
> driver when invalid parameters are requested and I would like to see some
> other code to make difference (between driver and firmware error).
>
> regards
> Antti
>
>
> On 05/03/2015 04:00 PM, Olli Salonen wrote:
>>
>> Return error from si2168_cmd_execute in case the demodulator returns an
>> error.
>>
>> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
>> ---
>>   drivers/media/dvb-frontends/si2168.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/media/dvb-frontends/si2168.c
>> b/drivers/media/dvb-frontends/si2168.c
>> index 29a5936..b68ab34 100644
>> --- a/drivers/media/dvb-frontends/si2168.c
>> +++ b/drivers/media/dvb-frontends/si2168.c
>> @@ -60,6 +60,12 @@ static int si2168_cmd_execute(struct i2c_client
>> *client, struct si2168_cmd *cmd)
>>                                 jiffies_to_msecs(jiffies) -
>>                                 (jiffies_to_msecs(timeout) - TIMEOUT));
>>
>> +               /* error bit set? */
>> +               if ((cmd->args[0] >> 6) & 0x01) {
>> +                       ret = -EREMOTEIO;
>> +                       goto err_mutex_unlock;
>> +               }
>> +
>>                 if (!((cmd->args[0] >> 7) & 0x01)) {
>>                         ret = -ETIMEDOUT;
>>                         goto err_mutex_unlock;
>>
>
> --
> http://palosaari.fi/

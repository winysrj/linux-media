Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52407 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932850AbbBBNmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 08:42:54 -0500
Message-ID: <54CF7EB2.9020109@xs4all.nl>
Date: Mon, 02 Feb 2015 14:42:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	=?windows-1252?Q?Richard_R=F6jfors?=
	<richard.rojfors@mocean-labs.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 03/15] [media] adv7180: Use inline function instead
 of macro
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>	<1422028354-31891-4-git-send-email-lars@metafoo.de> <20150202113613.07673af0@recife.lan>
In-Reply-To: <20150202113613.07673af0@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/2015 02:36 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 23 Jan 2015 16:52:22 +0100
> Lars-Peter Clausen <lars@metafoo.de> escreveu:
> 
>> Use a inline function instead of a macro for the container_of helper for
>> getting the driver's state struct from a control. A inline function has the
>> advantage that it is more typesafe and nicer in general.
> 
> I don't see any advantage on this.
> 
> See: container_of is already a macro, and it is written in a way that, if
> you use it with inconsistent values, the compilation will break.
> 
> Also, there's the risk that, for whatever reason, gcc to decide to not
> inline this.

For the record: I disagree with this. I think a static inline is more readable
than a macro. It is also consistent with other existing i2c subdev drivers since
they all use a static inline as well. And if in rare cases gcc might decide not
to inline this, then so what? You really won't notice any difference. It's an
i2c device, so it's slow as molasses anyway. Readability is much more important
IMHO.

On the other hand, it's not critical enough for me to make a big deal out of
it if this patch is dropped.

Regards,

	Hans

> 
> So, this doesn't sound a good idea.
> 
> Regards,
> Mauro
> 
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/i2c/adv7180.c | 13 +++++++------
>>  1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
>> index f424a4d..f2508abe 100644
>> --- a/drivers/media/i2c/adv7180.c
>> +++ b/drivers/media/i2c/adv7180.c
>> @@ -130,9 +130,11 @@ struct adv7180_state {
>>  	bool			powered;
>>  	u8			input;
>>  };
>> -#define to_adv7180_sd(_ctrl) (&container_of(_ctrl->handler,		\
>> -					    struct adv7180_state,	\
>> -					    ctrl_hdl)->sd)
>> +
>> +static struct adv7180_state *ctrl_to_adv7180(struct v4l2_ctrl *ctrl)
>> +{
>> +	return container_of(ctrl->handler, struct adv7180_state, ctrl_hdl);
>> +}
>>  
>>  static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
>>  {
>> @@ -345,9 +347,8 @@ static int adv7180_s_power(struct v4l2_subdev *sd, int on)
>>  
>>  static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
>>  {
>> -	struct v4l2_subdev *sd = to_adv7180_sd(ctrl);
>> -	struct adv7180_state *state = to_state(sd);
>> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +	struct adv7180_state *state = ctrl_to_adv7180(ctrl);
>> +	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
>>  	int ret = mutex_lock_interruptible(&state->mutex);
>>  	int val;
>>  


Return-Path: <ricardo.ribalda@gmail.com>
In-reply-to: <1805679.hlRzVeq61B@avalon>
References: <1424185706-16711-1-git-send-email-ricardo.ribalda@gmail.com>
 <54EAED82.5040804@xs4all.nl> <1805679.hlRzVeq61B@avalon>
MIME-version: 1.0
Content-type: multipart/alternative; boundary=----WPUV1O3OJHS8AUHO3E2XFEN3EEGLBP
Content-transfer-encoding: 8bit
Subject: Re: [PATCH v4 1/2] media/v4l2-ctrls: Always run s_ctrl on volatile
 ctrls
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 24 Feb 2015 06:42:53 +0700
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <BCBD9AA6-F7D0-48EE-8157-C935461E6297@gmail.com>
List-ID: <linux-media.vger.kernel.org>

------WPUV1O3OJHS8AUHO3E2XFEN3EEGLBP
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"

Hello Hans and Laurent


I understand volatile as a control that can change its value by the device. So in that sense I think that my control is volatile and writeable (ack by the user).

The value written by the user is meaning-less in my usercase, but in another s it could be useful.

I am outside the office and with no computer for the next two weeks. If you can wait until then I can implement Hans idea or another one and try it out with my hw.  I can reply mails with my phone thought.

Thanks for considering my usercase :)


Regards



On 24 February 2015 06:07:49 GMT+07:00, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>Hi Hans,
>
>On Monday 23 February 2015 10:06:10 Hans Verkuil wrote:
>> On 02/17/2015 04:08 PM, Ricardo Ribalda Delgado wrote:
>> > Volatile controls can change their value outside the v4l-ctrl
>framework.
>> > We should ignore the cached written value of the ctrl when
>evaluating if
>> > we should run s_ctrl.
>> 
>> I've been thinking some more about this (also due to some comments
>Laurent
>> made on irc), and I think this should be done differently.
>> 
>> What you want to do here is to signal that setting this control will
>execute
>> some action that needs to happen even if the same value is set twice.
>> 
>> That's not really covered by VOLATILE. Interestingly, the WRITE_ONLY
>flag is
>> to be used for just that purpose, but this happens to be a R/W
>control, so
>> that can't be used either.
>> 
>> What is needed is the following:
>> 
>> 1) Add a new flag: V4L2_CTRL_FLAG_ACTION.
>> 2) Any control that sets FLAG_WRITE_ONLY should OR it with
>FLAG_ACTION (to
>>    keep the current meaning of WRITE_ONLY).
>> 3) Any control with FLAG_ACTION set should return changed == true in
>>    cluster_changed.
>> 4) Any control with FLAG_VOLATILE set should set ctrl->has_changed to
>false
>>    to prevent generating the CH_VALUE control (that's a real bug).
>> 
>> Your control will now set FLAG_ACTION and FLAG_VOLATILE and it will
>do the
>> right thing.
>
>I'm not sure about Ricardo's use case, is it the one we've discussed on
>#v4l ? 
>If so, and if I recall correctly, the idea was to perform an action
>with a 
>parameter, and didn't require volatility.
>
>> Basically what was missing was a flag to explicitly signal this
>'writing
>> executes an action' behavior. Trying to shoehorn that into the
>volatile
>> flag or the write_only flag is just not right. It's a flag in its own
>right.
>
>Just for the sake of exploring all options, what did you think about
>the idea 
>of making button controls accept a value ?
>
>Your proposal is interesting as well, but I'm not sure about the 
>V4L2_CTRL_FLAG_ACTION name. Aren't all controls supposed to have an
>action of 
>some sort ? That's nitpicking of course.
>
>Also, should the action flag be automatically set for button controls ?
>Button 
>controls would in a way become type-less controls with the action flag
>set, 
>that's interesting. I suppose type-less controls without the action
>flag don't 
>make sense.
>
>> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> > ---
>> > v4: Hans Verkuil:
>> > 
>> > explicity set has_changed to false. and add comment
>> > 
>> >  drivers/media/v4l2-core/v4l2-ctrls.c | 11 +++++++++++
>> >  1 file changed, 11 insertions(+)
>
>-- 
>Regards,
>
>Laurent Pinchart

-- 
Ricardo Ribalda
Sent from my Android device with K-9 Mail. Please excuse my brevity.
------WPUV1O3OJHS8AUHO3E2XFEN3EEGLBP
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html><head></head><body>Hello Hans and Laurent<br>
<br>
<br>
I understand volatile as a control that can change its value by the device. So in that sense I think that my control is volatile and writeable (ack by the user).<br>
<br>
The value written by the user is meaning-less in my usercase, but in another s it could be useful.<br>
<br>
I am outside the office and with no computer for the next two weeks. If you can wait until then I can implement Hans idea or another one and try it out with my hw.  I can reply mails with my phone thought.<br>
<br>
Thanks for considering my usercase :)<br>
<br>
<br>
Regards<br>
<br>
<br><br><div class="gmail_quote">On 24 February 2015 06:07:49 GMT+07:00, Laurent Pinchart &lt;laurent.pinchart@ideasonboard.com&gt; wrote:<blockquote class="gmail_quote" style="margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
<pre class="k9mail">Hi Hans,<br /><br />On Monday 23 February 2015 10:06:10 Hans Verkuil wrote:<br /><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"> On 02/17/2015 04:08 PM, Ricardo Ribalda Delgado wrote:<br /><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #ad7fa8; padding-left: 1ex;"> Volatile controls can change their value outside the v4l-ctrl framework.<br /> We should ignore the cached written value of the ctrl when evaluating if<br /> we should run s_ctrl.<br /></blockquote> <br /> I've been thinking some more about this (also due to some comments Laurent<br /> made on irc), and I think this should be done differently.<br /> <br /> What you want to do here is to signal that setting this control will execute<br /> some action that needs to happen even if the same value is set twice.<br /> <br /> That's not really covered by VOLATILE. Interestingly, the WRITE_ON
 LY flag
is<br /> to be used for just that purpose, but this happens to be a R/W control, so<br /> that can't be used either.<br /> <br /> What is needed is the following:<br /> <br /> 1) Add a new flag: V4L2_CTRL_FLAG_ACTION.<br /> 2) Any control that sets FLAG_WRITE_ONLY should OR it with FLAG_ACTION (to<br />    keep the current meaning of WRITE_ONLY).<br /> 3) Any control with FLAG_ACTION set should return changed == true in<br />    cluster_changed.<br /> 4) Any control with FLAG_VOLATILE set should set ctrl-&gt;has_changed to false<br />    to prevent generating the CH_VALUE control (that's a real bug).<br /> <br /> Your control will now set FLAG_ACTION and FLAG_VOLATILE and it will do the<br /> right thing.<br /></blockquote><br />I'm not sure about Ricardo's use case, is it the one we've discussed on #v4l ? <br />If so, and if I recall correctly, the idea was to perform an action with a <br />parameter, and didn't require volatility.<br /><br /><blockquote class="gmail_quote"
 
style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"> Basically what was missing was a flag to explicitly signal this 'writing<br /> executes an action' behavior. Trying to shoehorn that into the volatile<br /> flag or the write_only flag is just not right. It's a flag in its own right.<br /></blockquote><br />Just for the sake of exploring all options, what did you think about the idea <br />of making button controls accept a value ?<br /><br />Your proposal is interesting as well, but I'm not sure about the <br />V4L2_CTRL_FLAG_ACTION name. Aren't all controls supposed to have an action of <br />some sort ? That's nitpicking of course.<br /><br />Also, should the action flag be automatically set for button controls ? Button <br />controls would in a way become type-less controls with the action flag set, <br />that's interesting. I suppose type-less controls without the action flag don't <br />make sense.<br /><br /><blockquote class="gmail_
 quote"
style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"><blockquote class="gmail_quote" style="margin: 0pt 0pt 1ex 0.8ex; border-left: 1px solid #ad7fa8; padding-left: 1ex;"> Signed-off-by: Ricardo Ribalda Delgado &lt;ricardo.ribalda@gmail.com&gt;<br /> ---<br /> v4: Hans Verkuil:<br /> <br /> explicity set has_changed to false. and add comment<br /> <br />  drivers/media/v4l2-core/v4l2-ctrls.c | 11 +++++++++++<br />  1 file changed, 11 insertions(+)<br /></blockquote></blockquote></pre></blockquote></div><br>
-- <br>
Ricardo Ribalda<br>
Sent from my Android device with K-9 Mail. Please excuse my brevity.</body></html>
------WPUV1O3OJHS8AUHO3E2XFEN3EEGLBP--

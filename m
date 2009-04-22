Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s41.bay0.hotmail.com ([65.54.246.241]:49649 "EHLO
	bay0-omc3-s41.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbZDVChW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 22:37:22 -0400
Message-ID: <BAY102-W3864E0FADC1B6127940C3CF740@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: Steven Toth <stoth@linuxtv.org>, Ben <pghben@yahoo.com>
CC: <linux-media@vger.kernel.org>
Subject: RE: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
Date: Tue, 21 Apr 2009 21:37:22 -0500
In-Reply-To: <49EDF076.8030509@linuxtv.org>
References: <23cedc300904170207w74f50fc1v3858b663de61094c@mail.gmail.com>
 <BAY102-W34E8EA79DEE83E18177655CF7B0@phx.gbl> <49E9C4EA.30706@linuxtv.org>
  <loom.20090420T150829-849@post.gmane.org> <49EC9A08.50603@linuxtv.org>
  <1240245715.5388.126.camel@mountainboyzlinux0>
 <49ECA8DD.9090708@linuxtv.org>
  <1240249684.5388.146.camel@mountainboyzlinux0>
 <49ECBCF0.3060806@linuxtv.org>
  <1240255677.5388.153.camel@mountainboyzlinux0>
 <49ECD553.9090707@linuxtv.org>
  <1240259904.5388.178.camel@mountainboyzlinux0>
 <49ECEEA3.6010203@linuxtv.org>
  <1240265172.5388.184.camel@mountainboyzlinux0>
 <49ED269F.9030603@linuxtv.org>  <BAY102-W2235192D68B3F842A69215CF770@phx.gbl>
  <49EDF076.8030509@linuxtv.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I got it compiled and can tune channels.   Now i just need to get the frontend working.   "Thanks for checking into this Steve.


Tom

PS  Let me know when the patch gets committed and I will update the page you requested.

----------------------------------------
> Date: Tue, 21 Apr 2009 12:12:38 -0400
> From: stoth@linuxtv.org
> Subject: Re: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
> To: nickotym@hotmail.com
> CC: linux-media@vger.kernel.org
>
> Thomas Nicolai wrote:
>> Steve,
>>
>> still haven't figured out how not to top post with Hotmail, Sorry. :-) too much of a newb at this.
>
> Can't you scroll to the end of the email and insert your message?
>
>
>>
>> When I get your update below do I pull with the normal method or do I need to pull just from that link? What is the proper procedure for this?
>
> See below.
>
>>
>> Tom
>>
>>> Date: Mon, 20 Apr 2009 21:51:27 -0400
>>> From: stoth@linuxtv.org
>>> Subject: Re: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
>>> To: pghben@yahoo.com
>>> CC: linux-media@vger.kernel.org; mchehab@infradead.org
>>>
>>>> If there is anything I can do that will help you find the bug, please
>>>> let me know..
>>> The issue is fixed.
>>>
>>> http://linuxtv.org/hg/~stoth/cx23885-hvr1500/rev/7853c00870e1
>>>
>>> It's locking OK for me now. If you can clone, built and test - thus confirm the
>>> fix - that would be great.
>>>
>>> Build instructions on the wiki:
>>>
>>> http://linuxtv.org/wiki/index.php/How_to_Obtain%2C_Build_and_Install_V4L-DVB_Device_Drivers
>>>
>>> Thanks,
>>>
>>> - Steve
>
> Hey Tom,
>
> I spoke with Ben off-list. He has kindly offered to walk you through the clone,
> build and install mechanisms off-list, in other words a little one-to-one help.
> Rather than repeat his email address here, exposing his address, please look
> back through the mailing list and contact him directly.
>
> In the spirit of 'one good turn', if you can spend a few minutes to update the
> hvr-1500 product page on the linuxtv.org wiki
> (http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1500) then you'd be
> helping another user in the future :)
>
> - Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Rediscover Hotmail®: Get quick friend updates right in your inbox. 
http://windowslive.com/RediscoverHotmail?ocid=TXT_TAGLM_WL_HM_Rediscover_Updates2_042009
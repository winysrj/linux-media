Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KiSBC-0007V1-Be
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 13:05:11 +0200
Message-ID: <48DA1EDD.3020502@gmail.com>
Date: Wed, 24 Sep 2008 15:05:01 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
References: <20080923181628.10797e0b@mchehab.chehab.org>	<48D9F6F3.8090501@gmail.com>	<alpine.LRH.1.10.0809241051170.12985@pub3.ifh.de>
	<48DA15A2.40109@gmail.com>
In-Reply-To: <48DA15A2.40109@gmail.com>
Content-Type: multipart/mixed; boundary="------------020203090206080704030001"
Cc: DVB ML <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------020203090206080704030001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Manu Abraham wrote:
> Patrick Boettcher wrote:
>> Manu,
>>
>> On Wed, 24 Sep 2008, Manu Abraham wrote:
>>
>>> Mauro Carvalho Chehab wrote:
>>> [..]
>>>> The main arguments in favor of S2API over Multiproto are:
>>>>
>>> [..]
>>>
>>>>     - Capability of allowing improvements even on the existing
>>>> standards,
>>>>       like allowing diversity control that starts to appear on newer DVB
>>>>       devices.
>>>
>>> I just heard from Patrick, what he meant by this at the meeting and the
>>> reason why he voted for S2API, due to a fact that he was convinced
>>> incorrectly. Multiproto _already_has_ this implementation, while it is
>>> non-existant in S2API.
>> In order to not have people getting me wrong here, I'm stating now in
>> public:
>>
>> 1) I like the idea of having diversity optionally controlled by the
>> application.
>>
>> 2) My vote for S2API is final.
>>
>> It is final, because the S2API is mainly affecting
>> include/linux/dvb/frontend.h to add user-API support for new standards.
>> I prefer the user-API of S2API over the one of multiproto because of 1).
> 
> After adding in diversity to frontend.h,
> 
> Would you prefer to update the diversity related event on the event list
> as well ?

Patch attached for the user space API to multiproto, it updates the
event list as well. If it looks ok, i will push this changeset out as well.


Regards,
Manu

--------------020203090206080704030001
Content-Type: text/x-patch;
 name="diverisity.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diverisity.diff"

--- multiproto.orig/linux/include/linux/dvb/frontend.h	2008-09-24 14:06:49.000000000 +0400
+++ multiproto/linux/include/linux/dvb/frontend.h	2008-09-24 14:58:02.000000000 +0400
@@ -466,6 +466,7 @@ struct dvbt_params {
 	enum dvbfe_hierarchy		hierarchy;
 	enum dvbfe_alpha		alpha;
 	enum dvbfe_stream_priority	priority;
+	__u8				diversity;
 
 	__u8				pad[32];
 };
@@ -502,6 +503,7 @@ struct dvbh_params {
 	enum dvbfe_mpefec		mpefec;
 	enum dvbfe_timeslicing		timeslicing;
 	enum dvbfe_stream_priority	priority;
+	__u8				diversity;
 
 	__u32				bandwidth;
 	__u8				pad[32];
@@ -566,6 +568,7 @@ struct dvbfe_dvbc_info {
 struct dvbfe_dvbt_info {
 	enum dvbfe_modulation		modulation;
 	enum dvbfe_stream_priority	stream_priority;
+	__u8				diversity;
 
 	__u8				pad[32];
 };
@@ -574,6 +577,7 @@ struct dvbfe_dvbt_info {
 struct dvbfe_dvbh_info {
 	enum dvbfe_modulation		modulation;
 	enum dvbfe_stream_priority	stream_priority;
+	__u8				diversity;
 
 	__u8				pad[32];
 };
@@ -623,6 +627,7 @@ enum dvbfe_status {
 	DVBFE_HAS_SYNC			= (1 <<  3),	/*  SYNC found			*/
 	DVBFE_HAS_LOCK			= (1 <<  4),	/*  OK ..			*/
 	DVBFE_TIMEDOUT			= (1 <<  5),	/*  no lock in last ~2 s	*/
+	DVBFE_DIVERSITY_TOGGLE		= (1 <<  6),    /* signal too low, toggling..	*/
 	DVBFE_STATUS_DUMMY		= (1 << 31)
 };
 

--------------020203090206080704030001
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020203090206080704030001--

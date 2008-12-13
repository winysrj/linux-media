Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rouge.crans.org ([138.231.136.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <braice@braice.net>) id 1LBcFT-00017o-2r
	for linux-dvb@linuxtv.org; Sat, 13 Dec 2008 22:42:08 +0100
Received: from localhost (localhost.crans.org [127.0.0.1])
	by rouge.crans.org (Postfix) with ESMTP id C6A54807D
	for <linux-dvb@linuxtv.org>; Sat, 13 Dec 2008 17:49:50 +0100 (CET)
Received: from rouge.crans.org ([10.231.136.3])
	by localhost (rouge.crans.org [10.231.136.3]) (amavisd-new, port 10024)
	with LMTP id 2udGgoVJDu1I for <linux-dvb@linuxtv.org>;
	Sat, 13 Dec 2008 17:49:50 +0100 (CET)
Received: from [192.168.1.10] (205.pool85-50-79.dynamic.orange.es
	[85.50.79.205])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rouge.crans.org (Postfix) with ESMTP id 7C2868073
	for <linux-dvb@linuxtv.org>; Sat, 13 Dec 2008 17:49:50 +0100 (CET)
Message-ID: <4943E7AD.3020608@braice.net>
Date: Sat, 13 Dec 2008 17:49:49 +0100
From: Brice DUBOST <braice@braice.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem with libdvben50221
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello

I'm currently playing around with the libdvben50221
I started from the code of gnutv and zap_ca
It works very well but I have one problem.

When I close the cam my program is freezed when I do :

cam_params->stdcam->destroy(cam_params->stdcam, 1);

cam_params is a structure wich contains my cam parameters

I looked a bit more in the code and I discover that the freezing point is :
 pthread_mutex_lock(&tl->slots[slot_id].slot_lock);

  I give you some manual backtrace :
  en50221_tl_destroy_slot(llci->tl, llci->tl_slot_id);
  llci_cam_removed(llci);
  static void en50221_stdcam_llci_destroy(struct en50221_stdcam *stdcam,
int closefd)

Gnutv does not experience this freezing.

Do you have an idea of what can it be ?

Regards,



-- 
Brice

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

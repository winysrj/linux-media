Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <folkert@vanheusden.com>) id 1OjcDE-0004fq-VR
	for linux-dvb@linuxtv.org; Thu, 12 Aug 2010 20:09:09 +0200
Received: from keetweej.vanheusden.com ([83.163.219.98])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1OjcDE-0005Kf-1J; Thu, 12 Aug 2010 20:09:08 +0200
Received: from belle.intranet.vanheusden.com (belle.intranet.vanheusden.com
	[192.168.64.100])
	by keetweej.vanheusden.com (Postfix) with ESMTP id A9A648013
	for <linux-dvb@linuxtv.org>; Thu, 12 Aug 2010 20:09:03 +0200 (CEST)
Date: Thu, 12 Aug 2010 20:09:03 +0200
From: folkert <folkert@vanheusden.com>
To: linux-dvb@linuxtv.org
Message-ID: <20100812180903.GF31128@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
Subject: [linux-dvb] getting the 0ccd:0097 TerraTec Electronic GmbH Cinergy
	T RC MKII	to work
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Got my new 0ccd:0097 TerraTec Electronic GmbH Cinergy T RC MKII to work
with kernel 2.6.34 and the patchset from hg clone http://linuxtv.org/hg/v4l-dvb
Found a patch for doing so at
http://forum.ubuntuusers.de/topic/probleme-beim-installieren-terratec-cinergy-t/5/?highlight=j#post-2487346
which I also attached to this mail.
Submitted the patch to the guy who wrote the other cinergy driver.
Please consider merging it into the tree.


Thanks!

Folkert van Heusden

-- 
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

--OXfL5xGRrasGEqWY
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="cinergy-stick-rc.patch.gz"
Content-Transfer-Encoding: base64

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
tK/txfCaXM8nxoK8uxyQhlwluTZ85vck3qVqjSKlVqtKiipiQqZkzieW7lq0lf11e/ym4Zs7
xO2jxOnBdU4Ffajiccec+HN7le/URJ+GNmTgQ9skx5CYLcbfyJAMwKV9If3jvR1N+HISuqMG
3UmWFdPVrUz0bRjBA8Akw2H3kkyMfxeh9YSV+Vau5+VkERGvnphtl95oaRVYkMf/PJ6mMSen
ifyM5+1rvuR6MOx32ue4Z3MOkMT325azSR3jOLDqUwdZIKurPoFF73euVcZXawYLihQ+ijE1
6zGNgWuGNad+fVmXK4p+fHF2Qnujgb0Sqf2+A7W6m1qVI7K1ZwHW/+EzlnRrKRYPmyxPg+om
/6vhNEF0o6XU4kQjSCsNGonxS1V89xrkn9Qz4OvGdc8hrq3SJKt4xPIF9gYRk4bYPCa/y6eK
69WjrzvJttyvTvKKLuTexhTyY53fXOXXag9p7uCvkpPErOdsCdrVn61dNaRdqfq99Gsk6Bfc
DX9yDyoh+1ZeTf8YIOKpFZrn0FuNJLemyRHJGZbJ/i4TNZ+nqN5Qd62gSASTyFibMnXmFbkq
MlZ6qgjPZ9C1Cj7oU0+Va7KuhvP7uFSZTYi60kqX/YMw9pMloStOoVbFap+t9Da1EvVhrV7D
aabZgd/B9zL3Gbc3/po+dMve+9a9mHoTc+4CfrGtC7pwRvQHuwt1hR9dwGHJFmHUY1FB8KiR
Uq2JGbObaBuJ0mAkdZaYR1fwC3uMGXwcSvgv8xB6ba85svCwv0TYxSh6M9GvqYVqKljzP/fr
8blKWQAA

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--OXfL5xGRrasGEqWY--

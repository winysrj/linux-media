Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2N94wRL010467
	for <video4linux-list@redhat.com>; Tue, 23 Mar 2010 05:04:59 -0400
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2N94mHB002308
	for <video4linux-list@redhat.com>; Tue, 23 Mar 2010 05:04:49 -0400
Message-ID: <4BA7E97D.9020605@dtlm.homelinux.net>
Date: Tue, 23 Mar 2010 09:04:45 +1100
From: Daniel Rose <drose@dtlm.homelinux.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Dvico hell
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I have the problem referenced here.


http://forums.whirlpool.net.au/forum-replies-archive.cfm/521910.html

Because ABC has this weird offset thingy:

ABC TV Canberra:205625000:INVERSION_OFF:BANDWIDTH_7_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:529

The 625 part is not present in the other stations.

I've downloaded and am running the latest drivers, as far as I know, using the instructions here:

http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers

If I use a different DTV card, the station tunes fine, so it's not my antenna.

Can anyone help me out please?  The card is this:

http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/dd4_rev1.jpg

and is discussed in an old page here:

http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/


I would *really* appreciate some help.

Thanks!



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

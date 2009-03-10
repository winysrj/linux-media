Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2AD6GQ6019410
	for <video4linux-list@redhat.com>; Tue, 10 Mar 2009 09:06:16 -0400
Received: from QMTA02.westchester.pa.mail.comcast.net
	(qmta02.westchester.pa.mail.comcast.net [76.96.62.24])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2AD5u1W013718
	for <video4linux-list@redhat.com>; Tue, 10 Mar 2009 09:05:56 -0400
Received: from server.deerrun.lnet (apkenned@localhost [127.0.0.1])
	by server.deerrun.lnet (8.14.3/8.14.3/Debian-5) with ESMTP id
	n2AD5sV3028907
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <video4linux-list@redhat.com>; Tue, 10 Mar 2009 08:05:54 -0500
From: spamtree@comcast.net (A. P. Kennedy)
To: video4linux-list@redhat.com
Date: Tue, 10 Mar 2009 08:05:53 -0500
Message-ID: <87hc21h6j2.fsf@spamtree.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: ir-kbd-i2c - Universal Remote does not work anymore.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

Summary of problem.

I have been using the ir-kbd-i2c module for several years with an
one-for-all universal remote. I have a pvr-350 and the original gray
hauppauge remote was broken. There was a change in the code in the
ir-kbd-i2c module that started filtering remote device ids and only a
hauppauge remote can work with the pvr-350 (or any other hauppauge version). 

Start of long version. 

I decided to upgrade my kernel and the remote stopped working. After
some searching on the net, I found out why the one-for-all universal
remote has stopped working. The following code was added to the
ir-kbd-i2c module.


    /*
     * Hauppauge remotes (black/silver) always use
     * specific device ids. If we do not filter the
     * device ids then messages destined for devices
     * such as TVs (id=0) will get through causing
     * mis-fired events.
     *
     * We also filter out invalid key presses which
     * produce annoying debug log entries.
     */
    ircode= (start << 12) | (toggle << 11) | (dev << 6) | code;
    if ((ircode & 0x1fff)==0x1fff)
        /* invalid key press */
        return 0;

    if (dev!=0x1e && dev!=0x1f)
        /* not a hauppauge remote */
        return 0;

By removing the last three lines the one-for-all universal remote now works
just fine, or changing the device id in the above code to the universal
remote everything works fine. 

I have never had the problem that the code is supposed to fix. I have never
had a misfired event discussed above. I have a key programmed for the
universal remote for the hauppauge and this solution has worked great for
the last several years. The device id for the one-for-all remote is 5 and
the device id cannot be changed on the remote. 

I am requesting that an option be added to send the module another device id
or to turn the device id filtering off. I am not a programmer or developer so
I do not know which way would be best to proceed.

Any help with this problem would be greatly appreciated. 

Thanks,

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

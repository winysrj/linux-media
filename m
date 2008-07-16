Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6G9pAOu019038
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 05:51:10 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6G9oxZ7003843
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 05:51:00 -0400
Received: by wf-out-1314.google.com with SMTP id 25so4725281wfc.6
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 02:50:59 -0700 (PDT)
Message-ID: <854cfb380807160250o6164f1b3q4a91908123c2cb04@mail.gmail.com>
Date: Wed, 16 Jul 2008 11:50:59 +0200
From: "=?ISO-8859-1?Q?Willem_Granj=E9?=" <willem.granje@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: dvbstream problem
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

dear all,

wanting to make a lightweight streamer for the radio stations of my
dvb-t card, it seems that the show already stops at the dvbstream
command, help please ...

here is what I have:

tzap -r xyz + kill after lock:
dvbstream -a xyz_audio_pid -o > test.m2t
(file remains empty)

tzap -r xyz and in another terminal:
dvbstream -a xyz_audio_pid -o > test.m2t
(complaint over: Failed setting filter for pid xyz_audio_pid: DMX SET
PES FILTER: Invalid argument)
(it does record xyz)

tzap -r xyz and in another terminal:
dvbstream xyz_audio_pid -o > test.m2t
(works, but why leave tzap running, and note the absence of '-a')

tzap -r xyz and in another terminal:
dvbstream some_other_audio_pid_on_this_frequency -o > test.m2t
(recording xyz and not the other pid)

hope you can help me,
will

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m22NVXpa001518
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 18:31:33 -0500
Received: from binford3000.de ([85.131.186.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m22NV1cJ001266
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 18:31:01 -0500
Received: from [192.168.178.3] (p57B0ACCA.dip0.t-ipconnect.de [87.176.172.202])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by binford3000.de (Postfix) with ESMTP id 8135B5C5F4
	for <video4linux-list@redhat.com>; Sun,  2 Mar 2008 23:32:36 +0100 (CET)
Message-ID: <47CB2B0E.9010003@binford3000.de>
Date: Sun, 02 Mar 2008 23:32:46 +0100
From: Janosch Peters <jp@binford3000.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: "no such device" when calling read()
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

Hi!

I just started learning v4l2. Im trying to write a small program which 
captures one frame and then terminates. The ioctl calls are all working, 
but when I call read() it fails, telling me that there is "no such 
device". Although I just used this very file descriptor to do the ioctl 
stuff. It is no I guess I'm missing something important. Any help is 
appreciated.

Im using a QuickCam for Notebooks (the current model). I already 
checked, that this cam supports the read() I/O. The output of the code 
beneath is:

---- output ------
Device sucessfuly opened.
read(): No such device
----------------------


---- code -------------------------------------------
int main()
{
    int fd = open("/dev/video0",O_RDWR);

    if( fd == -1 ) {
        // error message here
    }
    else {
        cout << "Device sucessfuly opened." << endl;
    }

    // save one image and exit
    int mb = 1048576;
    char* buf = new char[mb]; // 1MB
    ssize_t bytesRead = read(fd, buf, mb);

    if (-1 == bytesRead ) {
        perror ("read()");
        exit (EXIT_FAILURE);
    }
}
-------------------------------------------------------------

The file descriptor looks like this:
---------
crw-rw----  1 root   video    81,   0 2008-03-02 23:10 video0
---------

I am in the video group. I even ran the program as root.


cheers,
Janosch

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

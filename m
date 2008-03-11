Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2BDCQno004781
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 09:12:26 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.251])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2BDBikf009856
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 09:11:44 -0400
Received: by an-out-0708.google.com with SMTP id c31so644599ana.124
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 06:11:44 -0700 (PDT)
Message-ID: <bd41c5f0803110611o6990350es494c152be56020f4@mail.gmail.com>
Date: Tue, 11 Mar 2008 13:11:43 +0000
From: "Chaogui Zhang" <czhang1974@gmail.com>
To: "Brandon Rader" <brandon.rader@gmail.com>
In-Reply-To: <331d2cab0803102036i66455f79h1cf20ca7a0d5e22f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <331d2cab0803062218x663ad17ofb79928059a111b@mail.gmail.com>
	<bd41c5f0803081850o3b818d0ar633fbf0b50bc5535@mail.gmail.com>
	<!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAHFaDeWDc9dOji7t+LhHe7YBAAAAAA==@sbg0.com>
	<bd41c5f0803091305n1332ea0ai1acf5ffc07d0bd8d@mail.gmail.com>
	<331d2cab0803102036i66455f79h1cf20ca7a0d5e22f@mail.gmail.com>
Cc: video4linux-list <video4linux-list@redhat.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Trying to setup PCTV HD Card 800i
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

On Tue, Mar 11, 2008 at 3:36 AM, Brandon Rader <brandon.rader@gmail.com> wrote:
> I tried the different repo that you suggested, and get the same error.  Here
> is my new dmesg output http://pastebin.com/m4d43d4ef
>
> Brandon
>
>

Please do not drop the list from the cc. Use the "reply to all"
function of your email client instead of just "reply".

It seems the i2c bus is not working the way it should. Can you try the
following? (With the current v4l-dvb tree)

First, unload all the modules related to your card (cx88-*, s5h1409, xc5000).
Then, load cx88xx with options i2c_debug=1 and i2c_scan=1
Post the relevant dmesg output to the list.

-- 
Chaogui Zhang

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

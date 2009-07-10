Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:26842 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbZGJQjw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 12:39:52 -0400
Received: by fg-out-1718.google.com with SMTP id e21so283272fga.17
        for <linux-media@vger.kernel.org>; Fri, 10 Jul 2009 09:39:49 -0700 (PDT)
Date: Fri, 10 Jul 2009 18:40:35 +0200
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Help on mapping Media Center remote
From: Samuel Rakitnican <semirocket@gmail.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=windows-1250
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.uwu1xurj80yj81@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

With the huge help of Hermann, I managed to implement this remote with  
it's new card Compro VideoMate Vista T750F card=169 (just a copy of T750  
with a diff keymap). I successfully compiled v4l and managed to get this  
remote to work.

I need some help on mapping specific MCE buttons, since I don't know how  
remotes on linux function, or how MCE function. I just ran into this  
adventure, and stuck here.

Please, reply with missing values, correcting the wrong ones (if there are  
any) so that I can finish keymap for this remote. Or with a hint what to  
enter here.

Thanks in advance

---------------------------------------

Picture of the remote: http://i28.tinypic.com/1z5j500.jpg


/*
   Number in commment coresponds to remote button
   found in mce.gif and T750F-ENG.pdf manual.
*/

	[ 0x1d ] = KEY_0,
	[ 0x1e ] = KEY_1,
	[ 0x1f ] = KEY_2,
	[ 0x20 ] = KEY_3,
	[ 0x21 ] = KEY_4,
	[ 0x22 ] = KEY_5,
	[ 0x23 ] = KEY_6,
	[ 0x24 ] = KEY_7,
	[ 0x25 ] = KEY_8,
	[ 0x26 ] = KEY_9,

	[ 0x01 ] = KEY_POWER,	// 10
//	[ 0x31 ] =	/* 11 "Videos (MCE)"      */
//	[ 0x33 ] =	/* 12 "Radio (MCE)"       */
//	[ 0x2f ] =	/* 13 "Music (MCE)"       */
//	[ 0x30 ] =	/* 14 "Pictures (MCE)"    */
//	[ 0x2d ] =	/* 15 "Recorded TV (MCE)" */
//	[ 0x17 ] =	/* 16 "MCE Guide"         */
//	[ 0x2c ] =	/* 17 "Live TV (MCE)"     */
//	[ 0x2b ] =	/* 18 "DVD Menu (MCE)"    */
//	[ 0x32 ] =	/* 19 "DVD Sub (MCE)"     */
	[ 0x11 ] = KEY_UP,	// 20
	[ 0x13 ] = KEY_LEFT,	// 21
	[ 0x12 ] = KEY_DOWN,	// 22
	[ 0x14 ] = KEY_RIGHT,	// 23
	[ 0x15 ] = KEY_OK,	// 24
	[ 0x16 ] = KEY_BACK,	// 25
//	[ 0x02 ] =		/* 26 "Media Center"      */
//	[ 0x04 ] =		// 27  >> TV app in win goes fullscreen/restore, or in  
manual says "More" for MCE
	[ 0x05 ] = KEY_VOLUMEUP,	// 28
	[ 0x06 ] = KEY_VOLUMEDOWN,	// 29
	[ 0x03 ] = KEY_MUTE,		// 30
	[ 0x07 ] = KEY_CHANNELUP,	// 31
	[ 0x08 ] = KEY_CHANNELDOWN,	// 32
	[ 0x0c ] = KEY_RECORD,	// 33
	[ 0x0e ] = KEY_STOP,	// 34
	[ 0x0a ] = KEY_REWIND,	// 35
	[ 0x0b ] = KEY_PLAY,	// 36
	[ 0x09 ] = KEY_FASTFORWARD,	// 37
	[ 0x10 ] = KEY_PREVIOUSSONG,	/* 38 "Skip rewind"       */
	[ 0x0d ] = KEY_PAUSE,		// 39
	[ 0x0f ] = KEY_NEXTSONG,	/* 40 "Skip Forward"      */
//	[ 0x2a ] =		/* 41 The "*" button      */
//	[ 0x29 ] =		/* 42 The "#" button       */
	[ 0x27 ] = KEY_CLEAR,	// 43
//	[ 0x34 ] =		// 44   >> This one turn on/off TV app in win
	[ 0x28 ] = KEY_ENTER,	// 45
	[ 0x19 ] = KEY_RED,	// 46
	[ 0x1a ] = KEY_GREEN,	// 47
	[ 0x1b ] = KEY_YELLOW,	// 48
	[ 0x1c ] = KEY_BLUE,	// 49
	[ 0x18 ] = KEY_TEXT,	// 50 "Teletext on/off"

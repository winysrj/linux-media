Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1JmuVS-0001H8-Fx
	for linux-dvb@linuxtv.org; Fri, 18 Apr 2008 19:36:15 +0200
Received: by fg-out-1718.google.com with SMTP id 22so489026fge.25
	for <linux-dvb@linuxtv.org>; Fri, 18 Apr 2008 10:36:10 -0700 (PDT)
Message-ID: <4808DBFF.9020600@gmail.com>
Date: Fri, 18 Apr 2008 19:35:59 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
From: e9hack <e9hack@googlemail.com>
Subject: [linux-dvb] compile error
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

Hi,

compiling of the current hg tree fails with the following message:

   CC [M]  /usr/src/v4l-dvb/v4l/flexcop-pci.o
In file included from /usr/src/v4l-dvb/v4l/flexcop-common.h:12,
                  from /usr/src/v4l-dvb/v4l/flexcop-pci.c:10:
/usr/src/v4l-dvb/v4l/compat.h:539: error: static declaration of 'proc_create' follows 
non-static declaration
/usr/src/linux-2.6.25/include/linux/proc_fs.h:128: error: previous declaration of 
'proc_create' was here
make[5]: *** [/usr/src/v4l-dvb/v4l/flexcop-pci.o] Error 1

This patch does fix the problem:

diff -r 6aa6656852cb v4l/compat.h
--- a/v4l/compat.h      Wed Apr 16 13:13:15 2008 -0300
+++ b/v4l/compat.h      Fri Apr 18 19:33:38 2008 +0200
@@ -533,6 +533,7 @@ do { 
       \
         le16_to_cpu(get_unaligned((unsigned short *)(a)))
  #define put_unaligned_le16(r, a)                               \
         put_unaligned(cpu_to_le16(r), ((unsigned short *)(a)))
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25)
  #ifdef CONFIG_PROC_FS
  static inline struct proc_dir_entry *proc_create(const char *a,
         mode_t b, struct proc_dir_entry *c, const struct file_operations *d)
@@ -549,5 +550,6 @@ static inline struct proc_dir_entry *pro
  }
  #endif
  #endif
-
-#endif
+#endif
+
+#endif

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
